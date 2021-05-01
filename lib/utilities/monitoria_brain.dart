import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:multi_image_picker/multi_image_picker.dart';
import 'general_functions_brain.dart';

class MonitoriaBrain extends ChangeNotifier {
  final _firestore = Firestore.instance;
//  final _firestorage = FirebaseStorage.instance;

  bool modoMonitor = false;

  int selectedChatUnreadMessages;

  Future<void> get currentChatUnreadMessages async {
    QuerySnapshot messagesSnapshot = await _firestore
        .collection('dados_monitoria_online')
        .document(selectedMonitoriaData.monitoria)
        .collection(getChatScreenName(receiverRA))
        .getDocuments();

    int unreadMessagesCount = 0;
    MessageData lastMessageData = MessageData();
//      print('oioio' + lastMessageData.text);

    for (var message in messagesSnapshot.documents) {
      if (message.data['sender'] == receiverRA && !message.data['read']) {
        unreadMessagesCount++;
      }
    }

    selectedChatUnreadMessages = unreadMessagesCount;
    notifyListeners();
  }

  List<String> listaMonitoriasModoMonitorOff = [];
  List<String> listaMonitoriasModoMonitorOn = [];

  void modoMonitorChange(bool value) {
    modoMonitor = value;
    notifyListeners();
  }

  int _tagNumber = 0;

  String get getTagNumberInsteadOfNull {
    _tagNumber++;
    return _tagNumber.toString();
  }

  int selectedPhotoPage;
  bool uiVisibleOnImageViewer = true;

  void get changeUIVisibility {
    uiVisibleOnImageViewer = !uiVisibleOnImageViewer;
    notifyListeners();
  }

  PageController mediaViewPageController;

  void changeMediaViewerPage(int newPage) {
    selectedPhotoPage = newPage;
    mediaViewPageController = PageController(initialPage: newPage);
    notifyListeners();
  }

  void setupMediaViewerScreen({@required String photoPath}) {
    selectedPhotoPage = currentChatGalleryPaths.indexOf(photoPath);
  }

  Future<String> get messageTextForGalleryInfo async {
    try {
      String messageID = currentChatGalleryPaths[selectedPhotoPage]
          .split('/')
          .last
          .split('.jpg')
          .first;

      DocumentSnapshot message = await _firestore
          .collection('dados_monitoria_online')
          .document(selectedMonitoriaData.monitoria)
          .collection(getChatScreenName(receiverRA))
          .document(messageID)
          .get();

      return message.data['message'];
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, String>> getMessageInfoGalleryTopArea() async {
    try {
      String messageID = currentChatGalleryPaths[selectedPhotoPage]
          .split('/')
          .last
          .split('.jpg')
          .first;

      DocumentSnapshot message = await _firestore
          .collection('dados_monitoria_online')
          .document(selectedMonitoriaData.monitoria)
          .collection(getChatScreenName(receiverRA))
          .document(messageID)
          .get();

      String userName;
      if (message.data['sender'] != senderRA) {
        final UserBrain currentMessageUserBrain = UserBrain();
        await currentMessageUserBrain.setUser(userRA: message.data['sender']);
        userName = currentMessageUserBrain.getUserName();
      } else {
        userName = 'Você';
      }

      return {
        'sender': userName,
        'time': GeneralFunctionsBrain.getFormattedTime(
              fromIso8601String: message.data['time'],
              forceDayOfTheWeekOrFullDate: true,
            ) +
            ' ' +
            GeneralFunctionsBrain.getFormattedTime(
              fromIso8601String: message.data['time'],
              forceHoursAndMinutes: true,
            ),
      };
    } catch (e) {
      print('ERRO em getMessageOnMediaView: $e');
      return {
        'sender': null,
        'time': null,
      };
    }
  }

  bool viewingMessagesScreen = false;

  String senderRA;
  String receiverRA;
  String receiverPhoneNumber;
  dynamic receiverUid;

  List<String> _currentChatGalleryPathsRaw = [];

  List<String> get currentChatGalleryPaths => _currentChatGalleryPathsRaw;

  void resetCurrentGallery() {
    _currentChatGalleryPathsRaw.clear();
    notifyListeners();
  }

  Future<void> getCurrentChatGallery() async {
    _currentChatGalleryPathsRaw.clear();
    String collectionChatName = getChatScreenName(receiverRA);
    await for (var snapshot in _firestore
        .collection('dados_monitoria_online')
        .document(selectedMonitoriaData.monitoria)
        .collection(collectionChatName)
        .snapshots()) {
      for (var message in snapshot.documents) {
        if (message.data['photo'] != null &&
            !_currentChatGalleryPathsRaw.contains(message.data['photo'])) {
          _currentChatGalleryPathsRaw.add(message.data['photo']);
        }
      }
    }
  }

  Future<void> initializeReadMessageListener(String receiverRA) async {
    String collectionChatName = getChatScreenName(receiverRA);
    await for (var snapshot in _firestore
        .collection('dados_monitoria_online')
        .document(selectedMonitoriaData.monitoria)
        .collection(collectionChatName)
        .snapshots()) {
      for (var message in snapshot.documents) {
        if (message.data['sender'] == receiverRA && viewingMessagesScreen) {
          await _firestore
              .collection('dados_monitoria_online')
              .document(selectedMonitoriaData.monitoria)
              .collection(collectionChatName)
              .document(message.documentID)
              .updateData({'read': true});
        }

        if (message.data['photo'] != null &&
            !_currentChatGalleryPathsRaw.contains(message.data['photo'])) {
          _currentChatGalleryPathsRaw.add(message.data['photo']);
        }
      }
    }
  }

  Stream<DocumentSnapshot> getAllChatsOfMonitoriaDataStream(String monitoria) =>
      _firestore
          .collection('dados_monitoria_online')
          .document(monitoria)
          .snapshots();

  Future<List<dynamic>> getMonitoresDataFirebase(String monitoria) async {
    try {
      DocumentSnapshot monitoriaDocument = await _firestore
          .collection('dados_monitoria_online')
          .document(monitoria)
          .get();
      if (!monitoriaDocument.exists) {
        print('ERRO em getMonitoresRA: $monitoria não existe');
        return null;
      }
//      print(monitoriaDocument.data['monitores']);
      return monitoriaDocument.data['monitores'];
    } catch (e) {
      print('ERRO em getMonitoresRA: $e');
      return null;
    }
  }

  Stream<QuerySnapshot> getMessagesStream({monitoria, String otherRA}) {
    print(
        'hi: ${monitoria ?? selectedMonitoriaData.monitoria}: ${getChatScreenName(otherRA ?? receiverRA)}');
    return _firestore
        .collection('dados_monitoria_online')
        .document(monitoria ?? selectedMonitoriaData.monitoria)
        .collection(getChatScreenName(otherRA ?? receiverRA))
        .snapshots();
  }

  Future<Map<String, dynamic>> getMessageData(DocumentSnapshot message) async {
    final messagePhotoPath = message.data['photo'];

    Widget messageImage;

    if (messagePhotoPath != null) {
      try {
        messageImage = Image(
          fit: BoxFit.cover,
//          image: FirebaseStorageImage(messagePhotoPath),
        );
      } catch (e) {
        print(e);
        messageImage = Container(
          color: Colors.grey,
          child: Center(
            child: Text(
              'Não foi possível obter imagem...',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        );
      }
    }

    return {
      'message': message.data['message'],
      'photo': messageImage,
      'sender': message.data['sender'],
      'time': message.data['time'],
      'read': message.data['read'],
    };
  }

  Stream<QuerySnapshot> getUsersDataStream() =>
      _firestore.collection('dados_usuarios').snapshots();

  String getChatScreenName(String otherRA,
      {String localRA, bool modoMonitorActive}) {
    String aluno;
    String monitor;
    if (modoMonitorActive ?? modoMonitor) {
      aluno = otherRA;
      monitor = localRA ?? senderRA;
    } else {
      monitor = otherRA;
      aluno = localRA ?? senderRA;
    }
    return '${monitor}_$aluno';
  }

  Map<String, MonitoriaCardInfo> monitoriaCardInfoMap = {};

  Future<void> getMonitoriaCardInfo({
    @required String monitoria,
  }) async {
    MonitoriaCardInfo monitoriaCardInfo;

    final monitoresDados =
        List.from((await getMonitoresDataFirebase(monitoria)) ?? []);

    monitoresDados.sort((a, b) => a['RA'].compareTo(b['RA']));

    List<ChatCardInfo> allMonitoriaCardsInfo = [];

    if (modoMonitor) {
      final allUsers =
          await _firestore.collection('dados_usuarios').getDocuments();

      for (var user in allUsers.documents) {
        final chatsMonitoria = await _firestore
            .collection('dados_monitoria_online')
            .document(monitoria)
            .collection(getChatScreenName(user.documentID))
            .getDocuments();

        if (List.from(chatsMonitoria.documents).length != 0) {
          if (user.documentID != senderRA) {
            ChatCardInfo chatCardInfo;
            try {
              await getMonitorChatCardInfo(
                monitoria: monitoria,
                otherUserRA: user.documentID,
              );
              chatCardInfo =
                  monitoresChatCardInfoMap[monitoria][user.documentID];
            } catch (e) {
              print('ERRO em getMonitoriaCardInfo: $e');
              chatCardInfo = ChatCardInfo(userDescription: 'ERRO');
            }

            allMonitoriaCardsInfo.add(chatCardInfo);
          }
        }
      }

      monitoriaCardInfo = MonitoriaCardInfo(
          monitoria: monitoria,
          monitorCardInfoList: GeneralFunctionsBrain.sortMonitorCardInfoList(
              allMonitoriaCardsInfo));
    } else {
      ChatCardInfo chatCardInfo;

      for (var monitorDados in monitoresDados) {
        String monitorRA = monitorDados['RA'];
        if (monitorRA != senderRA) {
          try {
            await getMonitorChatCardInfo(
              monitoria: monitoria,
              otherUserRA: monitorRA,
            );
            chatCardInfo = monitoresChatCardInfoMap[monitoria][monitorRA];
          } catch (e) {
            print(e);
            chatCardInfo = ChatCardInfo(userRA: 'ERRO');
          }

          allMonitoriaCardsInfo.add(chatCardInfo);
        }
      }

//          monitoriaAllChatCardsInfo.sort((a, b) {
//            return (b.lastMessageTimeInMilliseconds ?? 1)
//                .compareTo((a.lastMessageTimeInMilliseconds ?? 2));
//          });

      monitoriaCardInfo = MonitoriaCardInfo(
          monitoria: monitoria,
          monitorCardInfoList: GeneralFunctionsBrain.sortMonitorCardInfoList(
              allMonitoriaCardsInfo));
    }
    try {} catch (e) {
      print('ERRO em getMonitoriaCardInfo: $e');
      monitoriaCardInfo = MonitoriaCardInfo(
        monitoria: 'ERRO CRÍTICO',
        monitorCardInfoList: [
          ChatCardInfo(
            userRA: 'Erro na ordenação de contatos.',
          ),
        ],
      );
    }

    monitoriaCardInfoMap[monitoria] = monitoriaCardInfo;
  }

  Map<String, Map<String, ChatCardInfo>> monitoresChatCardInfoMap = {};

  Future<void> getMonitorChatCardInfo({
    @required String monitoria,
    @required String otherUserRA,
  }) async {
    // Obtendo informações do usuário que manda a mensagem:
    final UserBrain messageSenderUserBrain = UserBrain();
    await messageSenderUserBrain.setUser(userRA: senderRA);

    // Obtendo informações do usuário que recebe a mensagem:
    final UserBrain messageReceiverUserBrain = UserBrain();
    await messageReceiverUserBrain.setUser(userRA: otherUserRA);

    QuerySnapshot messagesSnapshot = await _firestore
        .collection('dados_monitoria_online')
        .document(monitoria ?? selectedMonitoriaData.monitoria)
        .collection(getChatScreenName(otherUserRA))
        .getDocuments();

    ChatCardInfo chatCardInfo;

//    while (currentChatMonitoriaBrain.chatMessagesSnapshot == null) {}

    try {
      // Calculando quantidade de mensagens não lidas pelo usuário que manda a mensagem:
      int unreadMessagesCount = 0;
      MessageData lastMessageData = MessageData();
//      print('oioio' + lastMessageData.text);

      for (var message in messagesSnapshot.documents) {
        if (message.data['sender'] == otherUserRA && !message.data['read']) {
          unreadMessagesCount++;
        }
      }

      // Obtendo dados da última mensagem mandada na conversa:
      final rawLastMessageData = messagesSnapshot.documents.last.data;
      String nomeUsuario = rawLastMessageData['sender'] == senderRA
          ? 'Você'
          : (await _firestore
              .collection('dados_usuarios')
              .document(rawLastMessageData['sender'])
              .get())['nome'];

      lastMessageData = MessageData(
        text: rawLastMessageData['message'],
        photo: rawLastMessageData['photo'],
        read: rawLastMessageData['read'],
        senderName: nomeUsuario,
        senderRA: rawLastMessageData['sender'],
        time: rawLastMessageData['time'],
      );

      // Se existe uma última mensagem, mande isso:
      chatCardInfo = ChatCardInfo(
        userName: messageReceiverUserBrain.getUserName(),
        userRA: otherUserRA,
        userUid: messageReceiverUserBrain.getUserUid(),
        userDescription: messageReceiverUserBrain.getFormattedUserDescription(),
        userImage: messageReceiverUserBrain.getUserImage(),
        monitorias: messageReceiverUserBrain.getUserMonitorias(),
        lastMessageData: lastMessageData,
        lastMessageSenderIsMe:
            lastMessageData.senderRA == messageSenderUserBrain.getUserRA(),
        unreadMessages: unreadMessagesCount,
        monitorType: GeneralFunctionsBrain.convertStringToMonitorType(
            (messageReceiverUserBrain.getUserMonitoriaFullMap()[monitoria] ??
                {})['tipo']),
      );
    } catch (e) {
      if (e.toString() == "Bad state: No element") {
        // Se não existe uma última mensagem, mande isso:
        chatCardInfo = ChatCardInfo(
          userName: messageReceiverUserBrain.getUserName(),
          userRA: otherUserRA,
          userUid: messageReceiverUserBrain.uid,
          userDescription:
              messageReceiverUserBrain.getFormattedUserDescription(),
          userImage: messageReceiverUserBrain.getUserImage(),
          monitorias: messageReceiverUserBrain.getUserMonitorias(),
          monitorType: GeneralFunctionsBrain.convertStringToMonitorType(
            (messageReceiverUserBrain.getUserMonitoriaFullMap()[monitoria] ??
                {})['tipo'],
          ),
        );
      } else {
        print('Erro em getMonitorChatCardInfo(): $e');
        chatCardInfo = ChatCardInfo(
          userName: 'ERRO em getMonitorChatCardInfo',
          lastMessageData: MessageData(text: '$e'),
        );
      }
    }

    if (!monitoresChatCardInfoMap.containsKey(monitoria))
      monitoresChatCardInfoMap[monitoria] = {};

    monitoresChatCardInfoMap[monitoria][otherUserRA] = chatCardInfo;
  }

  Map<String, Map<String, dynamic>> monitoresUserInfoMap = {};

  Future<void> getMonitoriaReceiverUserInfo() async {
    Map<String, dynamic> userInfo;

    try {
      final UserBrain monitoriaCardUserBrain = UserBrain();
      await monitoriaCardUserBrain.setUser(userRA: receiverRA);

      userInfo = {
        'userName': monitoriaCardUserBrain.getUserName(),
        'userDescription': monitoriaCardUserBrain.getFormattedUserDescription(),
        'userImage': monitoriaCardUserBrain.getUserImage(),
        'monitoria': monitoriaCardUserBrain.getUserMonitorias(),
        'monitorTypeMap': monitoriaCardUserBrain.getUserMonitoriaFullMap()
      };
    } catch (e) {
      print('Erro em getMonitoriaReceiverUserInfo(): $e');
      userInfo = {
        'userName': 'Erro ao carregar dados.',
        'userDescription': null,
        'userImage': null,
        'monitoria': null,
        'monitorTypeMap': null,
      };
    }

    monitoresUserInfoMap[receiverRA] = userInfo;
  }

  Future<void> sendMessage({
    List<dynamic> images,
    String text,
  }) async {
    DateTime time = DateTime.now();

    String documentName = '${time.millisecondsSinceEpoch}_$senderRA';

    String chatScreenName;

    chatScreenName = getChatScreenName(receiverRA);

    CollectionReference messageDataRef = _firestore
        .collection('dados_monitoria_online')
        .document(selectedMonitoriaData.monitoria)
        .collection(chatScreenName);

    if (images != null) {
      // Envio de Fotos:
//      int photoIndex = 1;
//      for (Asset photo in images) {
//        final String imageAddress =
//            'fotos_monitoria/${selectedMonitoriaData.monitoria.split('-')[0]}_$chatScreenName/$documentName-$photoIndex.jpg'
//                .replaceAll(' ', '');
//
//        final StorageReference firebaseStorageRef =
//            _firestorage.ref().child(imageAddress);
//
//        final StorageUploadTask photoRefTask = firebaseStorageRef
//            .putData((await photo.getByteData()).buffer.asUint8List());
//
//        photoRefTask.events.listen((event) {
//          messageDataRef.document('$documentName-$photoIndex').setData({
//            'message': photoIndex == images.length ? text : null,
//            'photo_uploading': true,
//            'photo': 'gs://estudamaua-ea6ad.appspot.com/$imageAddress',
//            'sender': senderRA,
//            'receiver': receiverRA,
//            'receiver_uid': receiverUid,
//            'time': time.toIso8601String(),
//            'read': false,
//          });
//        });
//
//        await photoRefTask.onComplete.then((snapshot) {
//          messageDataRef.document('$documentName-$photoIndex').updateData({
//            'photo_uploading': false,
//          });
//        });
//        photoIndex++;
//      }
    } else {
      messageDataRef.document(documentName).setData({
        'message': text,
        'photo_uploading': false,
        'photo': null,
        'sender': senderRA,
        'receiver': receiverRA,
        'receiver_uid': receiverUid,
        'time': time.toIso8601String(),
        'read': false,
      });
    }
  }

  MonitoriaCardInfo selectedMonitoriaData;

  Widget getImageMessageBubble(String messageImagePath) {
    Widget displayAsImage;
    try {
      displayAsImage = Image(
        fit: BoxFit.cover,
//        image: FirebaseStorageImage(messageImagePath),
      );
    } catch (e) {
      print(e);
      displayAsImage = Container(
        color: Colors.grey,
        child: Center(
          child: Text(
            'Não foi possível obter imagem...',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ),
      );
    }
    return displayAsImage;
  }

  void signOut() {
    modoMonitor = false;
    listaMonitoriasModoMonitorOn = [];
    listaMonitoriasModoMonitorOff = [];
    monitoriaCardInfoMap = {};
    monitoresChatCardInfoMap = {};
    monitoresUserInfoMap = {};
    selectedMonitoriaData = null;
    notifyListeners();
  }
}
