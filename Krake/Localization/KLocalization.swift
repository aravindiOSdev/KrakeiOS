// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
@objc public class KLocalization: NSObject {
  /// Scarsa qualità del segnale GPS
  @objc public static let badLocationAccuracy = KLocalization.tr("OCLocalizable", "Bad location accuracy")
  /// Categoria
  @objc public static let categoria = KLocalization.tr("OCLocalizable", "Categoria")
  /// Scegli o scatta una foto
  @objc public static let chooseTakePhoto = KLocalization.tr("OCLocalizable", "CHOOSE_TAKE_PHOTO")
  /// Descrizione
  @objc public static let descrizione = KLocalization.tr("OCLocalizable", "Descrizione")
  /// Inserisci la tua posizione
  @objc public static let erroreGps = KLocalization.tr("OCLocalizable", "ERRORE_GPS")
  /// ERRORE: Non è stato possibile inviare la segnalazione.\n
  @objc public static let erroreInvioSegn = KLocalization.tr("OCLocalizable", "ERRORE_INVIO_SEGN")
  /// galleria
  @objc public static let gallery = KLocalization.tr("OCLocalizable", "Gallery")
  /// Mappa
  @objc public static let mappa = KLocalization.tr("OCLocalizable", "Mappa")
  /// Per accedere a questa sezione devi prima aver attivato le Push!
  @objc public static let pushActivation = KLocalization.tr("OCLocalizable", "PUSH_ACTIVATION")
  /// Info generali
  @objc public static let relatedFields = KLocalization.tr("OCLocalizable", "RELATED_FIELDS")
  /// La tua segnalazione è stata inviata correttamente.\n
  @objc public static let segnSended = KLocalization.tr("OCLocalizable", "SEGN_SENDED")
  /// Sottotitolo
  @objc public static let sottotitolo = KLocalization.tr("OCLocalizable", "Sottotitolo")
  /// Titolo
  @objc public static let titolo = KLocalization.tr("OCLocalizable", "Titolo")

  @objc public class AppUpdate: NSObject {
    /// Aggiorna
    @objc public static let update = KLocalization.tr("OCLocalizable", "AppUpdate.update")
    /// Aggiornamento disponibile
    @objc public static let updateAvailable = KLocalization.tr("OCLocalizable", "AppUpdate.updateAvailable")
    /// Aggiornamento disponibile. Per continuare ad utilizzare l'App devi aggiornarla.
    @objc public static let updateAvailableMessage = KLocalization.tr("OCLocalizable", "AppUpdate.updateAvailableMessage")
  }

  @objc public class Beacon: NSObject {
    /// Offerte nel reparto %@
    @objc public static func notificationBody(_ p1: Any) -> String {
      return KLocalization.tr("OCLocalizable", "Beacon.notificationBody", String(describing: p1))
    }
  }

  @objc public class BodyPart: NSObject {
    /// messaggio
    @objc public static let text = KLocalization.tr("OCLocalizable", "BodyPart.Text")
  }

  @objc public class Calendar: NSObject {
    /// Evento aggiunto al calendario
    @objc public static let eventAdded = KLocalization.tr("OCLocalizable", "Calendar.eventAdded")
  }

  @objc public class Commons: NSObject {
    /// Accetta
    @objc public static let accept = KLocalization.tr("OCLocalizable", "Commons.accept")
    /// Aggiungi al calendario
    @objc public static let addToCalendar = KLocalization.tr("OCLocalizable", "Commons.addToCalendar")
    /// Tutti
    @objc public static let all = KLocalization.tr("OCLocalizable", "Commons.all")
    /// Sconosciuto
    @objc public static let anonymous = KLocalization.tr("OCLocalizable", "Commons.anonymous")
    /// Annulla
    @objc public static let cancel = KLocalization.tr("OCLocalizable", "Commons.cancel")
    /// Chiudi
    @objc public static let close = KLocalization.tr("OCLocalizable", "Commons.close")
    /// Completato
    @objc public static let completed = KLocalization.tr("OCLocalizable", "Commons.completed")
    /// Nega
    @objc public static let deny = KLocalization.tr("OCLocalizable", "Commons.deny")
    /// Conferma
    @objc public static let done = KLocalization.tr("OCLocalizable", "Commons.done")
    /// E-Mail
    @objc public static let eMail = KLocalization.tr("OCLocalizable", "Commons.eMail")
    /// Da
    @objc public static let from = KLocalization.tr("OCLocalizable", "Commons.from")
    /// Inserisci il testo da cercare
    @objc public static let insertTextToSearch = KLocalization.tr("OCLocalizable", "Commons.insertTextToSearch")
    /// Messaggio
    @objc public static let message = KLocalization.tr("OCLocalizable", "Commons.message")
    /// Avanti
    @objc public static let next = KLocalization.tr("OCLocalizable", "Commons.next")
    /// No
    @objc public static let no = KLocalization.tr("OCLocalizable", "Commons.no")
    /// Non ci sono elementi in questa sezione
    @objc public static let noElements = KLocalization.tr("OCLocalizable", "Commons.no_elements")
    /// Ok
    @objc public static let ok = KLocalization.tr("OCLocalizable", "Commons.ok")
    /// Caricamento in corso...
    @objc public static let onLoading = KLocalization.tr("OCLocalizable", "Commons.onLoading")
    /// Telefono
    @objc public static let phone = KLocalization.tr("OCLocalizable", "Commons.phone")
    /// obbligatorio
    @objc public static let `required` = KLocalization.tr("OCLocalizable", "Commons.required")
    /// Salva
    @objc public static let save = KLocalization.tr("OCLocalizable", "Commons.save")
    /// Cerca
    @objc public static let search = KLocalization.tr("OCLocalizable", "Commons.search")
    /// Invia
    @objc public static let send = KLocalization.tr("OCLocalizable", "Commons.send")
    /// Condividi
    @objc public static let share = KLocalization.tr("OCLocalizable", "Commons.share")
    /// A
    @objc public static let to = KLocalization.tr("OCLocalizable", "Commons.to")
    /// Attendere
    @objc public static let wait = KLocalization.tr("OCLocalizable", "Commons.wait")
    /// Sito web
    @objc public static let webSite = KLocalization.tr("OCLocalizable", "Commons.webSite")
    /// Si
    @objc public static let yes = KLocalization.tr("OCLocalizable", "Commons.yes")
  }

  @objc public class ContentModification: NSObject {
    /// Non salvare
    @objc public static let dontSave = KLocalization.tr("OCLocalizable", "ContentModification.dontSave")
    /// Hai raggiunto il numero massimo di elementi multimediali. Prima di procedere con l'aggiunta di un nuovo elemento devi cancellarne uno.
    @objc public static let mediaMaxNumberOfElem = KLocalization.tr("OCLocalizable", "ContentModification.media_max_number_of_elem")
    /// Vuoi chiudere e salvare il contenuto?
    @objc public static let quitAndSaveQuestion = KLocalization.tr("OCLocalizable", "ContentModification.quitAndSaveQuestion")
    /// Esci comunque
    @objc public static let quitAnyway = KLocalization.tr("OCLocalizable", "ContentModification.quitAnyway")
    /// Vuoi chiudere? Perderai le tue modifiche non salvate
    @objc public static let quitWithoutSaveQuestion = KLocalization.tr("OCLocalizable", "ContentModification.quitWithoutSaveQuestion")
  }

  @objc public class Core: NSObject {
    /// it-IT
    @objc public static let language = KLocalization.tr("OCLocalizable", "Core.language")
  }

  @objc public class Date: NSObject {
    /// Data
    @objc public static let date = KLocalization.tr("OCLocalizable", "Date.date")
    /// dal %@ al %@
    @objc public static func fromToDate(_ p1: Any, _ p2: Any) -> String {
      return KLocalization.tr("OCLocalizable", "Date.fromToDate", String(describing: p1), String(describing: p2))
    }
    /// dalle %@ alle %@
    @objc public static func fromToHour(_ p1: Any, _ p2: Any) -> String {
      return KLocalization.tr("OCLocalizable", "Date.fromToHour", String(describing: p1), String(describing: p2))
    }
    /// h
    @objc public static let hour = KLocalization.tr("OCLocalizable", "Date.hour")
    /// min.
    @objc public static let minute = KLocalization.tr("OCLocalizable", "Date.minute")
    /// %@
    @objc public static func on(_ p1: Any) -> String {
      return KLocalization.tr("OCLocalizable", "Date.on", String(describing: p1))
    }
    /// al
    @objc public static let toDate = KLocalization.tr("OCLocalizable", "Date.toDate")
  }

  @objc public class Error: NSObject {
    /// Azione non autorizzata
    @objc public static let actionNotAuthorized = KLocalization.tr("OCLocalizable", "Error.actionNotAuthorized")
    /// Non è possibile aprire il seguente url %@
    @objc public static func cantOpenThisUrl(_ p1: Any) -> String {
      return KLocalization.tr("OCLocalizable", "Error.cantOpenThisUrl", String(describing: p1))
    }
    /// Errore
    @objc public static let error = KLocalization.tr("OCLocalizable", "Error.error")
    /// Errore generico
    @objc public static let genericError = KLocalization.tr("OCLocalizable", "Error.genericError")
    /// Entry Point non valido
    @objc public static let invalidEntryPoint = KLocalization.tr("OCLocalizable", "Error.invalidEntryPoint")
    /// Errore di caricamento
    @objc public static let loadingOfUserInfoFailed = KLocalization.tr("OCLocalizable", "Error.loadingOfUserInfoFailed")
  }

  @objc public class Location: NSObject {
    /// Posizione
    @objc public static let location = KLocalization.tr("OCLocalizable", "Location.location")
    /// La mia posizione
    @objc public static let myLocation = KLocalization.tr("OCLocalizable", "Location.myLocation")
  }

  @objc public class MapPart: NSObject {
    /// posizione GPS
    @objc public static let latitude = KLocalization.tr("OCLocalizable", "MapPart.Latitude")
  }

  @objc public class Policies: NSObject {
    /// Accetto i suddetti termini.
    @objc public static let acceptTerm = KLocalization.tr("OCLocalizable", "Policies.acceptTerm")
    /// Uso commerciale
    @objc public static let commercialUse = KLocalization.tr("OCLocalizable", "Policies.CommercialUse")
    /// Confermo di aver preso visione.
    @objc public static let confirmRead = KLocalization.tr("OCLocalizable", "Policies.confirmRead")
    /// Gestione policy
    @objc public static let managePolicy = KLocalization.tr("OCLocalizable", "Policies.managePolicy")
    /// Policy
    @objc public static let policy = KLocalization.tr("OCLocalizable", "Policies.Policy")
    /// Regolamenti
    @objc public static let regulation = KLocalization.tr("OCLocalizable", "Policies.Regulation")
    ///  * obbligatorio
    @objc public static let `required` = KLocalization.tr("OCLocalizable", "Policies.required")
    /// Cessione dati a terzi
    @objc public static let thirdParty = KLocalization.tr("OCLocalizable", "Policies.ThirdParty")
    /// Per procedere devi accettare l'informativa.
    @objc public static let undoPrivacy = KLocalization.tr("OCLocalizable", "Policies.undoPrivacy")
  }

  @objc public class PostCard: NSObject {
    /// E-Mail del destinatario non valida
    @objc public static let invalidRecipientMail = KLocalization.tr("OCLocalizable", "PostCard.invalidRecipientMail")
    /// E-Mail del mittente non valida
    @objc public static let invalidSenderMail = KLocalization.tr("OCLocalizable", "PostCard.invalidSenderMail")
    /// Inserisci il tuo commento
    @objc public static let missingComment = KLocalization.tr("OCLocalizable", "PostCard.missingComment")
    /// Mancano i seguenti campi:
    @objc public static let missingFollowingFields = KLocalization.tr("OCLocalizable", "PostCard.missingFollowingFields")
    /// Inserisci la mail del destinatario
    @objc public static let missingRecipientMail = KLocalization.tr("OCLocalizable", "PostCard.missingRecipientMail")
    /// Inserisci il nome del destinatario
    @objc public static let missingRecipientName = KLocalization.tr("OCLocalizable", "PostCard.missingRecipientName")
    /// Inserisci la tua mail
    @objc public static let missingSenderMail = KLocalization.tr("OCLocalizable", "PostCard.missingSenderMail")
    /// Inserisci il tuo nome
    @objc public static let missingSenderName = KLocalization.tr("OCLocalizable", "PostCard.missingSenderName")
    /// A e-mail
    @objc public static let toMail = KLocalization.tr("OCLocalizable", "PostCard.toMail")
    /// A nome
    @objc public static let toName = KLocalization.tr("OCLocalizable", "PostCard.toName")
    /// La tua e-mail
    @objc public static let yourMail = KLocalization.tr("OCLocalizable", "PostCard.yourMail")
    /// Il tuo nome
    @objc public static let yourName = KLocalization.tr("OCLocalizable", "PostCard.yourName")
  }

  @objc public class PushNotification: NSObject {
    /// %@\n\nVuoi saperne di più?
    @objc public static func vuoiAprirePush(_ p1: Any) -> String {
      return KLocalization.tr("OCLocalizable", "PushNotification.VUOI_APRIRE_PUSH", String(describing: p1))
    }
  }

  @objc public class Questionnaire: NSObject {
    /// Grazie per aver compilato il questionario
    @objc public static let completed = KLocalization.tr("OCLocalizable", "Questionnaire.COMPLETED")
    /// Non è stato possibile spedire il tuo questionario
    @objc public static let error = KLocalization.tr("OCLocalizable", "Questionnaire.ERROR")
    /// Complimenti, hai già compilato tutti i questionari. Torna presto a trovarci per contribuire ancora!
    @objc public static let notAvailable = KLocalization.tr("OCLocalizable", "Questionnaire.NOT_AVAILABLE")
    /// Non hai risposto a nessuna domanda
    @objc public static let notCompiled = KLocalization.tr("OCLocalizable", "Questionnaire.NOT_COMPILED")
    /// Devi compilare la domanda '%@' prima di poter inviare il questionario
    @objc public static func questionRequired(_ p1: Any) -> String {
      return KLocalization.tr("OCLocalizable", "Questionnaire.QUESTION_REQUIRED", String(describing: p1))
    }
  }

  @objc public class Reactions: NSObject {
    /// Arrabbiato
    @objc public static let angry = KLocalization.tr("OCLocalizable", "Reactions.angry")
    /// Noioso
    @objc public static let boring = KLocalization.tr("OCLocalizable", "Reactions.boring")
    /// Curioso
    @objc public static let curious = KLocalization.tr("OCLocalizable", "Reactions.curious")
    /// Emozionato
    @objc public static let excited = KLocalization.tr("OCLocalizable", "Reactions.excited")
    /// Esausto
    @objc public static let exhausted = KLocalization.tr("OCLocalizable", "Reactions.exhausted")
    /// Felice
    @objc public static let happy = KLocalization.tr("OCLocalizable", "Reactions.happy")
    /// Mi piace
    @objc public static let iLike = KLocalization.tr("OCLocalizable", "Reactions.i Like")
    /// Ci sono stato
    @objc public static let iWasThere = KLocalization.tr("OCLocalizable", "Reactions.i Was There")
    /// Interessato
    @objc public static let interested = KLocalization.tr("OCLocalizable", "Reactions.interested")
    /// Scherzo
    @objc public static let joke = KLocalization.tr("OCLocalizable", "Reactions.joke")
    /// Bacio
    @objc public static let kiss = KLocalization.tr("OCLocalizable", "Reactions.kiss")
    /// Amore
    @objc public static let love = KLocalization.tr("OCLocalizable", "Reactions.love")
    /// Panico
    @objc public static let pain = KLocalization.tr("OCLocalizable", "Reactions.pain")
    /// Triste
    @objc public static let sad = KLocalization.tr("OCLocalizable", "Reactions.sad")
    /// Scioccato
    @objc public static let shocked = KLocalization.tr("OCLocalizable", "Reactions.shocked")
    /// Silenzioso
    @objc public static let silent = KLocalization.tr("OCLocalizable", "Reactions.silent")
  }

  @objc public class Report: NSObject {
    /// Accettato
    @objc public static let accepted = KLocalization.tr("OCLocalizable", "Report.accepted")
    /// Creato
    @objc public static let created = KLocalization.tr("OCLocalizable", "Report.created")
    /// Caricato
    @objc public static let loaded = KLocalization.tr("OCLocalizable", "Report.loaded")
    /// Rifiutato
    @objc public static let rejected = KLocalization.tr("OCLocalizable", "Report.rejected")
  }

  @objc public class TitlePart: NSObject {
    /// titolo
    @objc public static let title = KLocalization.tr("OCLocalizable", "TitlePart.Title")
  }

  @objc public class UserAccess: NSObject {
    /// Confermi di voler inviare la procedura di recupero password al seguente numero?\n\n
    @objc public static let checkYourNumber = KLocalization.tr("OCLocalizable", "UserAccess.check_your_number")
    /// Conferma la password
    @objc public static let confirmPassword = KLocalization.tr("OCLocalizable", "UserAccess.confirm_password")
    /// Dominio
    @objc public static let domain = KLocalization.tr("OCLocalizable", "UserAccess.domain")
    /// Registrati
    @objc public static let doRegistration = KLocalization.tr("OCLocalizable", "UserAccess.doRegistration")
    /// Campo non compilato
    @objc public static let emptyField = KLocalization.tr("OCLocalizable", "UserAccess.empty_field")
    /// Accedi
    @objc public static let login = KLocalization.tr("OCLocalizable", "UserAccess.login")
    /// Accedi con
    @objc public static let loginWith = KLocalization.tr("OCLocalizable", "UserAccess.loginWith")
    /// Password dimenticata?
    @objc public static let lostPwd = KLocalization.tr("OCLocalizable", "UserAccess.lost_pwd")
    /// Password
    @objc public static let password = KLocalization.tr("OCLocalizable", "UserAccess.password")
    /// Numero di cellulare
    @objc public static let phoneNumber = KLocalization.tr("OCLocalizable", "UserAccess.phone_number")
    /// E-Mail
    @objc public static let placeholderMailRestorePassword = KLocalization.tr("OCLocalizable", "UserAccess.placeholder_mail_restore_password")
    /// Numero di telefono o la E-Mail
    @objc public static let placeholderSmsOrMailRestorePassword = KLocalization.tr("OCLocalizable", "UserAccess.placeholder_sms_or_mail_restore_password")
    /// Recupera password
    @objc public static let recoverPassword = KLocalization.tr("OCLocalizable", "UserAccess.recoverPassword")
    /// Registrazione
    @objc public static let registration = KLocalization.tr("OCLocalizable", "UserAccess.registration")
    /// Ti abbiamo appena inviato la tua nuova password.
    @objc public static let resetPasswordSended = KLocalization.tr("OCLocalizable", "UserAccess.reset_password_sended")
    /// Password dimenticata? Compila il form e riceverai un link per il reset della password.
    @objc public static let resetPwdMessage = KLocalization.tr("OCLocalizable", "UserAccess.reset_pwd_message")
    /// Numero non valido
    @objc public static let smsNotValid = KLocalization.tr("OCLocalizable", "UserAccess.sms_not_valid")
    /// Il tuo indirizzo di email é stato verificato
    @objc public static let verificationMailMessage = KLocalization.tr("OCLocalizable", "UserAccess.verificationMailMessage")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension KLocalization {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let libLocalized = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    let format = Bundle.main.localizedString(forKey: key, value: libLocalized, table: nil)
    return String(format: format, locale: Locale.current, arguments: args)
  }
  public static func ocLocalizable(_ key: String, _ args: CVarArg...) -> String {
    return tr("OCLocalizable", key, args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(url: Bundle.main.url(forResource: "Localization", withExtension: "bundle")!)!
    #endif
  }()
}
// swiftlint:enable convenience_type
