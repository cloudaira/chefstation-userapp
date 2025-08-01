import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chefstation_multivendor/api/api_client.dart';
import 'package:chefstation_multivendor/features/chat/domain/models/conversation_model.dart';
import 'package:chefstation_multivendor/features/chat/domain/models/message_model.dart';
import 'package:chefstation_multivendor/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:chefstation_multivendor/features/chat/domain/services/chat_service_interface.dart';
import 'package:chefstation_multivendor/features/chat/enums/user_type_enum.dart';
import 'package:chefstation_multivendor/features/notification/domain/models/notification_body_model.dart';

class ChatService implements ChatServiceInterface {
  final ChatRepositoryInterface chatRepositoryInterface;
  ChatService({required this.chatRepositoryInterface});

  @override
  Future<ConversationsModel?> getConversationList(offset, type) async {
    return await chatRepositoryInterface.getConversationList(offset, type);
  }

  @override
  bool checkSender(List<Conversation?>? conversations) {
    bool sender = false;
    for(int index=0; index<conversations!.length; index++) {
      if(conversations[index]!.receiverType == UserType.admin.name) {
        sender = true;
        break;
      }
    }
    return sender;
  }

  @override
  int setIndex(List<Conversation?>? conversations) {
    int index0 = -1;
    for(int index=0; index<conversations!.length; index++) {
      if(conversations[index]!.receiverType == UserType.admin.name) {
        index0 = index;
        break;
      }else if(conversations[index]!.receiverType == UserType.admin.name) {
        index0 = index;
        break;
      }
    }
    return index0;
  }

  @override
  Future<ConversationsModel> searchConversationList(name) async {
    return await chatRepositoryInterface.searchConversationList(name);
  }

  @override
  Future<Response> getMessages(int offset, int? userID, UserType userType, int? conversationID) async {
    return await chatRepositoryInterface.get(userID.toString(), offset: offset, userType: userType, conversationID: conversationID);
  }

  @override
  int findOutConversationUnreadIndex(List<Conversation?>? conversations, int? conversationID) {
    int index0 = -1;
    for(int index=0; index<conversations!.length; index++) {
      if(conversationID == conversations[index]!.id) {
        index0 = index;
        break;
      }
    }
    return index0;
  }

  @override
  Future<XFile> compressImage(XFile file) async {
    // final ImageFile input = ImageFile(filePath: file.path, rawBytes: await file.readAsBytes());
    // final Configuration config = Configuration(
    //   outputType: ImageOutputType.webpThenPng,
    //   useJpgPngNativeCompressor: false,
    //   quality: (input.sizeInBytes/1048576) < 2 ? 50 : (input.sizeInBytes/1048576) < 5
    //       ? 30 : (input.sizeInBytes/1048576) < 10 ? 2 : 1,
    // );
    // final ImageFile output = await compressor.compress(ImageFileConfiguration(input: input, config: config));
    // if(kDebugMode) {
    //   print('Input size : ${input.sizeInBytes / 1048576}');
    //   print('Output size : ${output.sizeInBytes / 1048576}');
    // }
    // return XFile.fromData(output.rawBytes);
    return file;
  }

  @override
  List<MultipartBody> processMultipartBody(List<XFile> chatImage, List<XFile> chatFiles, XFile? videoFile) {
    List<MultipartBody> multipartImages = [];

      for (var image in chatImage) {
        multipartImages.add(MultipartBody('image[]', image));
      }
    if(!GetPlatform.isWeb) {
      for (var file in chatFiles) {
        multipartImages.add(MultipartBody('image[]', file));
      }
      if (videoFile != null) {
        multipartImages.add(MultipartBody('image[]', videoFile));
      }
    }
    return multipartImages;
  }

  @override
  Future<MessageModel?> sendMessage(String message, List<MultipartBody> images, NotificationBodyModel? notificationBody, int? conversationID, List<MultipartDocument>? webFile, List<MultipartDocument>? webVideo) async {
    MessageModel? messageModel;
    if(notificationBody == null || notificationBody.adminId != null) {
      messageModel = await chatRepositoryInterface.sendMessage(message, images, 0, UserType.admin, null, webFile, webVideo);
    } else if(notificationBody.restaurantId != null) {
      messageModel = await chatRepositoryInterface.sendMessage(message, images, notificationBody.restaurantId, UserType.vendor, conversationID, webFile, webVideo);
    } else if(notificationBody.deliverymanId != null) {
      messageModel = await chatRepositoryInterface.sendMessage(message, images, notificationBody.deliverymanId, UserType.delivery_man, conversationID, webFile, webVideo);
    }
    return messageModel;
  }

}
