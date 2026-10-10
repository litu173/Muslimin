// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class L10nEs extends L10n {
  L10nEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Muslimin';

  @override
  String get tagline => 'Un día de la umma musulmana';

  @override
  String get next => 'Siguiente';

  @override
  String get skip => 'Omitir';

  @override
  String get cancel => 'Cancelar';

  @override
  String get getStarted => 'Empezar';

  @override
  String get create => 'Crear';

  @override
  String get update => 'Actualizar';

  @override
  String get edit => 'Editar';

  @override
  String get post => 'Publicar';

  @override
  String get save => 'Guardar';

  @override
  String get select => 'Seleccionar';

  @override
  String get retry => 'Reintentar';

  @override
  String get close => 'Cerrar';

  @override
  String get delete => 'Eliminar';

  @override
  String get done => 'Listo';

  @override
  String get viewAll => 'Ver todo';

  @override
  String get viewDetails => 'Ver detalles';

  @override
  String get dontShowAgain => 'No volver a mostrar';

  @override
  String get share => 'Compartir';

  @override
  String get addNew => 'Añadir nuevo';

  @override
  String get now => 'Ahora';

  @override
  String get selected => 'Seleccionado';

  @override
  String get home => 'Inicio';

  @override
  String get more => 'Más';

  @override
  String get loading => 'Cargando…';

  @override
  String get somethingWrong => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get onb1Title => 'Comparte los horarios de la yamaa';

  @override
  String get onb1Body =>
      'Las personas cercanas podrán ver en esta app los horarios de la oración en congregación de la mezquita.';

  @override
  String get onb2Title => 'Publica avisos de la mezquita';

  @override
  String get onb2Body =>
      'La gente encontrará los avisos de la mezquita en esta app, lo que les ayudará a participar en distintas ocasiones.';

  @override
  String get permTitle => 'Permite el acceso para continuar';

  @override
  String get permBody =>
      'Muslimin necesita tu ubicación para encontrar las mezquitas de tu zona, y las notificaciones para recordarte antes de la yamaa.';

  @override
  String get permLocation => 'Ubicación';

  @override
  String get permLocationBody =>
      'Encuentra las mezquitas más cercanas y calcula los horarios de oración con precisión.';

  @override
  String get permNotification => 'Notificaciones';

  @override
  String get permNotificationBody =>
      'Recordatorios de la yamaa y avisos de las mezquitas que sigues.';

  @override
  String get permAllow => 'Permitir';

  @override
  String get permGranted => 'Permitido';

  @override
  String get permOpenSettings => 'Abrir Ajustes';

  @override
  String get permLocationServiceOff =>
      'Activa la ubicación (GPS) de tu teléfono.';

  @override
  String get permDeniedForever =>
      'Se denegó el permiso. Actívalo desde Ajustes.';

  @override
  String get permContinue => 'Continuar';

  @override
  String get timeLeft => 'Tiempo restante';

  @override
  String get startsIn => 'Empieza en';

  @override
  String get allPrayers => 'Todas las oraciones';

  @override
  String get nearestMasjid => 'Mezquita más cercana';

  @override
  String get noMasjidNearby =>
      'Todavía no hay ninguna mezquita verificada cerca de ti.';

  @override
  String get noMasjidNearbyHint =>
      '¿Conoces a algún responsable de mezquita? Pídele que la registre en Muslimin.';

  @override
  String minWalk(String minutes) {
    return '$minutes min a pie';
  }

  @override
  String kmAway(String km) {
    return 'a $km km';
  }

  @override
  String get jamatNotSet => 'Horario de yamaa no definido';

  @override
  String get nextJamat => 'Próxima yamaa';

  @override
  String get notice => 'Aviso';

  @override
  String get notices => 'Avisos';

  @override
  String get noNotices => 'Aún no hay avisos.';

  @override
  String get all => 'Todos';

  @override
  String get authorityTitle => 'Responsables de mezquitas';

  @override
  String get authorityBody =>
      'Registra tu mezquita para que los musulmanes cercanos la descubran en esta app.';

  @override
  String get yourLocation => 'Tu ubicación';

  @override
  String get locating => 'Buscando ubicación…';

  @override
  String get useCurrentLocation => 'Usar ubicación actual';

  @override
  String get searchMasjid => 'Buscar mezquita';

  @override
  String get nearbyMasjids => 'Mezquitas cercanas';

  @override
  String get fajr => 'Fayr';

  @override
  String get sunrise => 'Amanecer';

  @override
  String get dhuhr => 'Dhuhr';

  @override
  String get asr => 'Asr';

  @override
  String get maghrib => 'Magrib';

  @override
  String get isha => 'Isha';

  @override
  String get jumuah => 'Yumu\'a';

  @override
  String get forbiddenTime => 'Momentos prohibidos';

  @override
  String get forbiddenInfo =>
      'No se reza en estos momentos: mientras sale el sol, cuando está en su cénit y mientras se pone.';

  @override
  String get morning => 'Mañana';

  @override
  String get noon => 'Mediodía';

  @override
  String get evening => 'Tarde';

  @override
  String get naflPrayers => 'Oraciones voluntarias';

  @override
  String get tahajjud => 'Tahayyud';

  @override
  String get duha => 'Oración del Duha';

  @override
  String get tahajjudHadith =>
      'El Mensajero de Allah (ﷺ) dijo: \"Nuestro Señor, Bendito y Altísimo, desciende cada noche al cielo más cercano cuando queda el último tercio de la noche, y dice: ¿Quién me invoca para que le responda? ¿Quién me pide para que le dé? ¿Quién me pide perdón para que le perdone?\"';

  @override
  String get tahajjudSource => 'Sahih al-Bujari 1145';

  @override
  String get duhaHadith1 =>
      'Abu Huraira dijo: \"Mi amigo, el Mensajero de Allah (ﷺ), me aconsejó tres cosas: ayunar tres días cada mes, rezar las dos rakas del Duha y rezar el witr antes de dormir.\"';

  @override
  String get duhaSource1 => 'Sahih al-Bujari y Muslim';

  @override
  String get duhaHadith2 =>
      'Nu\'aym ibn Hammar narró: El Mensajero de Allah (ﷺ) dijo: \"Allah, Poderoso y Majestuoso, dice: Hijo de Adán, no dejes de rezarme cuatro rakas al comienzo de tu día; Yo te bastaré hasta su final.\"';

  @override
  String get duhaSource2 => 'Sunan Abi Dawud 1289';

  @override
  String get calcMethodNote =>
      'Los horarios se calculan para tu ubicación. Los horarios de yamaa los fija cada mezquita.';

  @override
  String get following => 'Siguiendo';

  @override
  String get follow => 'Seguir';

  @override
  String get tabHome => 'Inicio';

  @override
  String get tabNotice => 'Avisos';

  @override
  String get tabLive => 'En directo';

  @override
  String get tabAbout => 'Información';

  @override
  String get jamatTime => 'Horarios de yamaa';

  @override
  String get maktabTime => 'Horario de la escuela coránica';

  @override
  String lastUpdated(String when) {
    return 'Actualizado $when';
  }

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String daysAgo(String count) {
    return 'hace $count días';
  }

  @override
  String get khatib => 'Jatib';

  @override
  String get imam => 'Imam';

  @override
  String get muazzin => 'Muecín';

  @override
  String contact(String phone) {
    return 'Contacto: $phone';
  }

  @override
  String get notAdded => 'Aún no añadido';

  @override
  String get jamatReminder => 'Recordatorio de yamaa';

  @override
  String get notifyBefore => 'Avisar antes';

  @override
  String minsBefore(String minutes) {
    return '$minutes min';
  }

  @override
  String get reminderOff => 'Desactivar recordatorio';

  @override
  String reminderSet(String minutes) {
    return 'Te avisaremos $minutes minutos antes de cada yamaa.';
  }

  @override
  String followedToast(String name) {
    return 'Ahora sigues $name.';
  }

  @override
  String get directions => 'Cómo llegar';

  @override
  String get liveNow => 'En directo';

  @override
  String get noLive => 'No hay transmisión en directo ahora';

  @override
  String get noLiveHint =>
      'Cuando la mezquita transmita una jutba o una charla, aparecerá aquí.';

  @override
  String get watchLive => 'Ver en directo';

  @override
  String get liveLink => 'Enlace de la transmisión (YouTube / Facebook)';

  @override
  String get liveToggle => 'Estamos en directo';

  @override
  String get maktabDays => 'Días de clase';

  @override
  String get weekdaysShort => 'sáb,dom,lun,mar,mié,jue,vie';

  @override
  String get weekdaysLong =>
      'sábado,domingo,lunes,martes,miércoles,jueves,viernes';

  @override
  String dayRange(String from, String to) {
    return '$from ~ $to';
  }

  @override
  String get tapToSet => 'Fijar';

  @override
  String get khatibName => 'Nombre del jatib';

  @override
  String get imamName => 'Nombre del imam';

  @override
  String get muazzinName => 'Nombre del muecín';

  @override
  String get contactNumber => 'Número de contacto';

  @override
  String get updated => 'Actualizado correctamente';

  @override
  String get writeNotice => 'Escribir aviso';

  @override
  String get selectCategory => 'Elegir categoría';

  @override
  String get deleteNoticeQ => '¿Eliminar este aviso?';

  @override
  String get catJanaza => 'Yanaza';

  @override
  String get catRecruitment => 'Empleo';

  @override
  String get catQuran => 'Clase de Corán';

  @override
  String get catQuranShort => 'Corán';

  @override
  String get catMahfil => 'Encuentro';

  @override
  String get catTalim => 'Ta\'lim';

  @override
  String get catTafsir => 'Tafsir';

  @override
  String get catGeneral => 'General';

  @override
  String get janazaNotice => 'Aviso de yanaza';

  @override
  String noticeFormTitle(String category) {
    return 'Aviso de $category';
  }

  @override
  String get enterCarefully =>
      'Introduce la siguiente información con cuidado.';

  @override
  String get personName => 'Nombre del difunto';

  @override
  String get fathersName => 'Nombre del padre';

  @override
  String get diedOn => 'Fecha de fallecimiento';

  @override
  String get address => 'Dirección';

  @override
  String get janazaTime => 'Hora de la yanaza';

  @override
  String get janazaDate => 'Fecha de la yanaza';

  @override
  String get noticeTitle => 'Título';

  @override
  String get noticeDetails => 'Detalles';

  @override
  String get date => 'Fecha';

  @override
  String get time => 'Hora';

  @override
  String deadline(String date) {
    return 'Fecha límite: $date';
  }

  @override
  String startingDate(String date) {
    return 'Fecha de inicio: $date';
  }

  @override
  String timeAndDate(String value) {
    return 'Hora y fecha: $value';
  }

  @override
  String janazaOf(String name) {
    return 'Yanaza de $name';
  }

  @override
  String sonOf(String name) {
    return 'Hijo/hija de $name';
  }

  @override
  String get noticePosted => 'Aviso publicado';

  @override
  String get required => 'Obligatorio';

  @override
  String get userAuth => 'Verificación de usuario';

  @override
  String get userAuthBody =>
      'Lee y acepta si lo siguiente se cumple en tu caso.';

  @override
  String get rule1 =>
      'Soy miembro del comité de la mezquita o su encargado/muecín/imam';

  @override
  String get rule2 =>
      'Puedo actualizar con regularidad los horarios de yamaa de la mezquita';

  @override
  String get rule3 => 'Entiendo el beneficio de esta app';

  @override
  String get rule4 => 'Marcaré la ubicación exacta de la mezquita';

  @override
  String get agreeAll => 'Confirma todas las afirmaciones para continuar.';

  @override
  String get registration => 'Registro';

  @override
  String get verifyMobile => 'Verifica tu número de móvil';

  @override
  String get yourMobile => 'Tu número de móvil';

  @override
  String get otpWillBeSent =>
      'Se enviará una contraseña de un solo uso (OTP) a este número para verificarlo';

  @override
  String get getOtp => 'Obtener OTP';

  @override
  String get invalidPhone =>
      'Introduce un número de móvil de Bangladés válido (01XXXXXXXXX).';

  @override
  String get verification => 'Verificación';

  @override
  String get typeOtp => 'Escribe el código OTP enviado a tu teléfono';

  @override
  String get otp => 'Contraseña de un solo uso (OTP)';

  @override
  String get didntGetOtp => '¿No recibiste el OTP?';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String resendIn(String seconds) {
    return 'Reenviar en $seconds s';
  }

  @override
  String get verify => 'Verificar';

  @override
  String get invalidOtp => 'El código no es correcto. Inténtalo de nuevo.';

  @override
  String get demoOtpHint => 'Modo demo: usa el código 123456';

  @override
  String get createMasjidProfile => 'Crear perfil de mezquita';

  @override
  String get stayInside =>
      'Introduce los datos con cuidado. Puedes fijar la ubicación desde dentro de la mezquita o en el mapa.';

  @override
  String get masjidName => 'Nombre de la mezquita';

  @override
  String get district => 'Distrito';

  @override
  String get thana => 'Thana / Upazila';

  @override
  String get latLng => 'Latitud y longitud';

  @override
  String get load => 'Cargar';

  @override
  String get reload => 'Volver a cargar';

  @override
  String get stayInsideLoading =>
      'Permanece dentro de la mezquita mientras carga.';

  @override
  String accuracy(String meters) {
    return 'Precisión ±$meters m';
  }

  @override
  String accuracyTooLow(String meters) {
    return 'La ubicación no es lo bastante precisa (±$meters m). Muévete a una zona abierta dentro de la mezquita y vuelve a cargar.';
  }

  @override
  String get loadLocationFirst => 'Fija la ubicación de la mezquita.';

  @override
  String get nidNumber => 'Tu número de DNI (NID)';

  @override
  String get invalidNid => 'El NID debe tener 10, 13 o 17 dígitos.';

  @override
  String get yourRole => 'Tu función';

  @override
  String get roleCommittee => 'Miembro del comité';

  @override
  String get roleKhadem => 'Encargado';

  @override
  String get roleMuazzin => 'Muecín';

  @override
  String get roleImam => 'Imam';

  @override
  String get roleKhatib => 'Jatib';

  @override
  String get agreeTermsPrefix => 'He leído y acepto los ';

  @override
  String get termsAndConditions => 'Términos y condiciones';

  @override
  String get mustAgreeTerms => 'Acepta los Términos y condiciones.';

  @override
  String duplicateFound(String name) {
    return 'Ya hay una mezquita llamada \"$name\" registrada en esta ubicación. Si eres su responsable, contacta con soporte.';
  }

  @override
  String limitReached(String count) {
    return 'Puedes tener como máximo $count perfiles de mezquita.';
  }

  @override
  String get submittedTitle => 'Enviado para revisión';

  @override
  String get submittedBody =>
      '¡Yazakallahu jairan! El perfil de tu mezquita será visible para todos cuando nuestro equipo lo verifique. Recibirás una notificación cuando se apruebe.';

  @override
  String get backToHome => 'Volver al inicio';

  @override
  String get termsBody =>
      '1. Solo los miembros del comité de la mezquita, el imam, el jatib, el muecín o el encargado pueden crear un perfil de mezquita.\n2. La ubicación de la mezquita debe ser exacta: fíjala con GPS desde dentro de la mezquita o señalándola en el mapa.\n3. Tu NID y tu número de teléfono solo se usan para la verificación y nunca se muestran públicamente.\n4. Los horarios de yamaa y los avisos deben ser correctos y estar actualizados.\n5. Los avisos deben estar relacionados con las actividades de la mezquita. No se permite contenido político, comercial ni de odio.\n6. El perfil permanece oculto hasta que lo verifica el equipo de Muslimin. Los perfiles con información falsa se eliminarán.';

  @override
  String get statusPending => 'Pendiente de revisión';

  @override
  String get statusApproved => 'Aprobado';

  @override
  String get statusRejected => 'Rechazado';

  @override
  String get statusSuspended => 'Suspendido';

  @override
  String get pendingBanner =>
      'Este perfil está esperando verificación. Solo tú puedes verlo.';

  @override
  String rejectedBanner(String reason) {
    return 'Este perfil no fue aprobado: $reason';
  }

  @override
  String get myMasjids => 'Mis mezquitas';

  @override
  String get registerMasjid => 'Registrar una mezquita';

  @override
  String get appSettings => 'Ajustes de la app';

  @override
  String get faq => 'Preguntas frecuentes';

  @override
  String get aboutApp => 'Acerca de la app';

  @override
  String get shareApp => 'Compartir esta app';

  @override
  String get shareAppBody =>
      'Esta app puede ayudar también a tu familia y amigos. Compártela.';

  @override
  String shareText(String url) {
    return 'Encuentra los horarios de yamaa de las mezquitas cercanas con Muslimin: $url';
  }

  @override
  String get language => 'Idioma';

  @override
  String get calcMethod => 'Cálculo de los horarios de oración';

  @override
  String get asrMethod => 'Cálculo del Asr';

  @override
  String get hanafi => 'Hanafí';

  @override
  String get shafi => 'Shafií / Malikí / Hanbalí';

  @override
  String get hijriAdjust => 'Ajuste de la fecha hégira';

  @override
  String days(String count) {
    return '$count días';
  }

  @override
  String get defaultReminder => 'Recordatorio de yamaa predeterminado';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String signedInAs(String phone) {
    return 'Sesión iniciada como $phone';
  }

  @override
  String version(String v) {
    return 'Versión $v';
  }

  @override
  String get aboutBody =>
      'Muslimin ayuda a los musulmanes a encontrar los horarios de yamaa de las mezquitas de su zona. Cada perfil de mezquita lo crea su propio responsable y lo verifica nuestro equipo antes de hacerse público.';

  @override
  String get faqQ1 => '¿De dónde salen los horarios de yamaa?';

  @override
  String get faqA1 =>
      'El responsable de cada mezquita fija y actualiza sus horarios de yamaa. La hora de entrada de cada oración se calcula para tu ubicación.';

  @override
  String get faqQ2 => '¿Por qué es obligatoria la ubicación?';

  @override
  String get faqA2 =>
      'La ubicación se usa para mostrar las mezquitas cercanas y calcular los horarios de oración con precisión. Nunca se comparte con nadie.';

  @override
  String get faqQ3 => '¿Cómo añado mi mezquita?';

  @override
  String get faqA3 =>
      'Ve a Más → Registrar una mezquita. Debes ser miembro del comité, imam, muecín, jatib o encargado, y fijar la ubicación exacta de la mezquita: con GPS desde dentro o en el mapa.';

  @override
  String get faqQ4 => '¿Por qué no aparece mi mezquita?';

  @override
  String get faqA4 =>
      'Nuestro equipo verifica los perfiles nuevos antes de hacerlos públicos. Suele tardar 1–2 días.';

  @override
  String get faqQ5 => '¿Cómo funcionan los recordatorios de yamaa?';

  @override
  String get faqA5 =>
      'Abre una mezquita y toca la campana en Horarios de yamaa. Te avisaremos 15, 30 o 45 minutos antes de cada yamaa, incluso con la app cerrada.';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get noNotifications => 'Sigue mezquitas para ver aquí sus avisos.';

  @override
  String get adminPanel => 'Panel de administración';

  @override
  String get adminPending => 'Pendientes';

  @override
  String get adminApproved => 'Aprobadas';

  @override
  String get adminRejected => 'Rechazadas';

  @override
  String get approve => 'Aprobar';

  @override
  String get reject => 'Rechazar';

  @override
  String get suspend => 'Suspender';

  @override
  String get restore => 'Restaurar';

  @override
  String get rejectReason => 'Motivo del rechazo';

  @override
  String get submittedBy => 'Enviado por';

  @override
  String get phone => 'Teléfono';

  @override
  String get nid => 'NID';

  @override
  String get role => 'Función';

  @override
  String get location => 'Ubicación';

  @override
  String get openInMaps => 'Abrir en Mapas';

  @override
  String get submittedOn => 'Enviado el';

  @override
  String get nothingHere => 'Aquí no hay nada';

  @override
  String get approvedToast => 'Mezquita aprobada';

  @override
  String get rejectedToast => 'Mezquita rechazada';

  @override
  String get verifiedChecklist =>
      'Antes de aprobar, llama a quien lo envió y comprueba la ubicación en el mapa.';

  @override
  String get verse1Ar => 'وَٱسْتَعِينُوا۟ بِٱلصَّبْرِ وَٱلصَّلَوٰةِ';

  @override
  String get verse1 => 'Buscad socorro en la paciencia y la oración.';

  @override
  String get verse1Ref => 'Al-Baqara 2:45';

  @override
  String get verse2Ar =>
      'إِنَّ ٱلصَّلَوٰةَ كَانَتْ عَلَى ٱلْمُؤْمِنِينَ كِتَـٰبًا مَّوْقُوتًا';

  @override
  String get verse2 =>
      'La oración ha sido prescrita a los creyentes para ser realizada en horarios específicos.';

  @override
  String get verse2Ref => 'An-Nisa 4:103';

  @override
  String get verse3Ar =>
      'حَـٰفِظُوا۟ عَلَى ٱلصَّلَوَٰتِ وَٱلصَّلَوٰةِ ٱلْوُسْطَىٰ';

  @override
  String get verse3 =>
      'Cumplid con la oración prescrita, especialmente la oración de la tarde';

  @override
  String get verse3Ref => 'Al-Baqara 2:238';

  @override
  String get hijriMonths =>
      'Muharram,Safar,Rabi al-Awwal,Rabi al-Zani,Yumada al-Ula,Yumada al-Ajira,Rayab,Shaabán,Ramadán,Shawwal,Dhul Qa\'da,Dhul Hiyya';

  @override
  String get deadlineLabel => 'Fecha límite';

  @override
  String get startingDateLabel => 'Fecha de inicio';

  @override
  String get masjidNameBn => 'Nombre de la mezquita en bengalí (opcional)';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get noAccount => '¿No tienes cuenta?';

  @override
  String get haveAccount => '¿Ya tienes cuenta?';

  @override
  String get signUpBody =>
      'Crea tu cuenta para seguir mezquitas y guardar tus ajustes de forma segura.';

  @override
  String get signInBody =>
      '¡Bienvenido de nuevo! Inicia sesión para continuar.';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get resetBody =>
      'Introduce el correo con el que te registraste. Te enviaremos un enlace para crear una contraseña nueva.';

  @override
  String get sendResetLink => 'Enviar enlace';

  @override
  String resetSent(String email) {
    return 'Hemos enviado un enlace para restablecer la contraseña a $email. Revisa tu bandeja de entrada (y la carpeta de spam).';
  }

  @override
  String get backToSignIn => 'Volver a iniciar sesión';

  @override
  String get invalidEmail => 'Introduce un correo electrónico válido.';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get passwordsDontMatch => 'Las contraseñas no coinciden.';

  @override
  String get errEmailInUse =>
      'Ya existe una cuenta con este correo. Prueba a iniciar sesión.';

  @override
  String get errInvalidCredential =>
      'El correo o la contraseña no son correctos.';

  @override
  String get errWeakPassword =>
      'Elige una contraseña más segura (al menos 6 caracteres).';

  @override
  String get errTooManyRequests =>
      'Demasiados intentos. Espera unos minutos e inténtalo de nuevo.';

  @override
  String get errNetwork => 'Sin conexión a internet. Inténtalo de nuevo.';

  @override
  String get errPhoneInUse =>
      'Este número de teléfono ya está vinculado a otra cuenta.';

  @override
  String get errUserDisabled =>
      'Esta cuenta se ha desactivado. Contacta con soporte.';

  @override
  String get myAccount => 'Mi cuenta';

  @override
  String get signInPrompt => 'Para responsables de mezquitas';

  @override
  String get signInPromptBody =>
      'Inicia sesión o crea una cuenta para registrar y gestionar tu mezquita. Los usuarios normales no necesitan cuenta.';

  @override
  String get profile => 'Perfil';

  @override
  String get emailNotVerified => 'Correo no verificado';

  @override
  String get emailVerified => 'Correo verificado';

  @override
  String get resendVerification => 'Enviar correo de verificación';

  @override
  String verificationSent(String email) {
    return 'Correo de verificación enviado a $email.';
  }

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get newPassword => 'Contraseña nueva';

  @override
  String get passwordChanged => 'Contraseña cambiada correctamente.';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountBody =>
      'Esto elimina de forma permanente tu cuenta y tus datos guardados. Los perfiles de mezquita que gestionas se mantendrán, pero perderás el acceso. Introduce tu contraseña para confirmar.';

  @override
  String get accountDeleted => 'Tu cuenta se ha eliminado.';

  @override
  String get phoneNumber => 'Teléfono';

  @override
  String get notVerified => 'No verificado';

  @override
  String welcomeUser(String name) {
    return '¡Bienvenido, $name!';
  }

  @override
  String get signInToRegister =>
      'Inicia sesión o crea una cuenta para registrar una mezquita.';

  @override
  String get verifyPhoneToContinue =>
      'Verifica tu número de teléfono para registrar una mezquita.';

  @override
  String accountCreated(String email) {
    return '¡Cuenta creada! Hemos enviado un enlace de verificación a $email.';
  }

  @override
  String get nameRequired => 'Introduce tu nombre.';

  @override
  String get credits => 'Créditos';

  @override
  String get fontCredits =>
      'Logo y nombres de las oraciones en inglés: rotulación del diseño de Muslimin, basada en Hidayatullah de Anthonie Van Hayu (ARToni). Tipografías: Grenze Gotisch de Omnibus-Type, Poppins de Indian Type Foundry y Jonny Pinhorn, Hind Siliguri de Indian Type Foundry, Anek Bangla (cifras bengalíes) de Ek Type, Galada de Black Foundry y Scheherazade New de SIL International. Todas son gratuitas bajo la SIL Open Font License 1.1.';

  @override
  String get designInspired =>
      'Tipografía del diseño original: Hidayatullah de Anthonie Van Hayu (ARToni).';

  @override
  String get openSourceLicenses => 'Licencias de código abierto';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get orDivider => 'o';

  @override
  String get onb3Title => 'Horarios de oración y recordatorios';

  @override
  String get onb3Body =>
      'Horarios de oración precisos para tu ubicación y un recordatorio antes de cada yamaa en las mezquitas que sigues.';

  @override
  String get appVersion => 'Versión de la app';

  @override
  String get checkingUpdates => 'Buscando actualizaciones…';

  @override
  String get upToDate => 'Tienes la última versión.';

  @override
  String updateAvailable(String version) {
    return 'Hay una nueva versión $version disponible';
  }

  @override
  String get downloadLatestApk => 'Descargar el último APK';

  @override
  String get updateApkHint =>
      'Abre el archivo descargado para instalarlo sobre esta versión. Tus ajustes se conservan.';

  @override
  String get updateIosButton => 'Cómo actualizar en iPhone';

  @override
  String get updateCheckFailed =>
      'No se pudieron buscar actualizaciones. Comprueba tu conexión a internet.';

  @override
  String get releaseNotes => 'Notas de la versión';

  @override
  String get selectAll => 'Seleccionar todo';

  @override
  String get welcomeTitle => 'Assalamu alaikum';

  @override
  String get welcomeBody =>
      'Inicia sesión para seguir tus mezquitas, recibir recordatorios de yamaa y mantener todo sincronizado en tus teléfonos.';

  @override
  String get continueAsGuest => 'Continuar como invitado';

  @override
  String get editMasjidInfo => 'Editar datos de la mezquita';

  @override
  String get editMasjidInfoBody =>
      'Actualiza los datos del perfil de tu mezquita, incluida su ubicación (GPS en la mezquita o elegida en el mapa).';

  @override
  String get followedMasjids => 'Mezquitas que sigues';

  @override
  String get noFollowed => 'Aún no sigues ninguna mezquita.';

  @override
  String get noFollowedHint =>
      'Abre una mezquita y toca Seguir para verla aquí y recibir sus avisos.';

  @override
  String reminderBadge(String minutes) {
    return 'Recordatorio $minutes min';
  }

  @override
  String get manageMasjids => 'Gestionar mezquitas';

  @override
  String get noMyMasjids => 'Aún no has registrado ninguna mezquita.';

  @override
  String get noMyMasjidsHint =>
      'Los miembros del comité, el imam, el jatib, el muecín o el encargado pueden registrar su mezquita. Nuestro equipo la verifica antes de hacerla pública.';

  @override
  String get appearance => 'Apariencia';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get appearanceHint =>
      'El modo oscuro descansa más la vista en Fayr e Isha.';

  @override
  String get pullToRefresh => 'Desliza hacia abajo para actualizar';

  @override
  String get verifyAutoCheck =>
      'Abre el enlace que te enviamos por correo; esta página se actualizará sola cuando estés verificado.';

  @override
  String get signOutTitle => '¿Cerrar sesión?';

  @override
  String get signOutBody =>
      'Tendrás que volver a iniciar sesión para ver tus mezquitas y recibir recordatorios de yamaa en este teléfono.';

  @override
  String jamatLine(String prayer, String time) {
    return 'Yamaa de $prayer $time';
  }

  @override
  String get scanBoard => 'Escanear el panel de horarios';

  @override
  String get scanBoardHint =>
      'Haz una foto del panel de horarios de la mezquita y todos los horarios de yamaa se rellenarán solos, o toca una hora para fijarla a mano.';

  @override
  String get takePhoto => 'Hacer una foto';

  @override
  String get chooseGallery => 'Elegir de la galería';

  @override
  String get scanStage1 => 'Mirando el panel de horarios…';

  @override
  String get scanStage2 => 'Leyendo los números…';

  @override
  String get scanStage3 => 'Emparejando de Fayr a Isha…';

  @override
  String get scanStage4 => 'Comprobando el Yumu\'a…';

  @override
  String scanFound(String count) {
    return 'Se encontraron $count horarios';
  }

  @override
  String get scanFailed =>
      'No se pudo leer esta foto. Prueba con una foto clara y recta del panel, o introduce los horarios a mano.';

  @override
  String get enterManually => 'Introducir a mano';

  @override
  String get scanReview =>
      'Horarios rellenados desde la foto (marcados con ✦). Revísalos y toca Actualizar.';

  @override
  String get tabRead => 'Leer';

  @override
  String get readQuran => 'Leer el Corán';

  @override
  String get journeySub => 'Tu recorrido por las 114 suras';

  @override
  String surahsProgress(String done) {
    return '$done de 114 suras';
  }

  @override
  String get versesRead => 'aleyas leídas';

  @override
  String get phasesDone => 'etapas completadas';

  @override
  String get continueReading => 'Continuar';

  @override
  String get startReading => 'Empezar a leer';

  @override
  String phaseN(String n) {
    return 'Etapa $n';
  }

  @override
  String versesN(String n) {
    return '$n aleyas';
  }

  @override
  String get completed => 'Completada';

  @override
  String get locked => 'Bloqueada';

  @override
  String ayahOf(String n, String total) {
    return 'Aleya $n de $total';
  }

  @override
  String unlockHint(String surah) {
    return 'Termina $surah para desbloquear esta sura.';
  }

  @override
  String get quizUnlockHint =>
      'Lee todas las suras de esta etapa para desbloquear su cuestionario.';

  @override
  String phaseQuiz(String n) {
    return 'Cuestionario de la etapa $n';
  }

  @override
  String get quizOptional => 'Opcional · pon a prueba lo que leíste';

  @override
  String bestScore(String score) {
    return 'Mejor $score %';
  }

  @override
  String get makki => 'Mequí';

  @override
  String get madani => 'Mediní';

  @override
  String get loadingSurah => 'Cargando la sura…';

  @override
  String get completeSurah => 'He terminado esta sura';

  @override
  String get nextSurah => 'Siguiente sura';

  @override
  String surahDone(String name) {
    return '¡MashaAllah! Has terminado la sura $name.';
  }

  @override
  String nextUnlocked(String name) {
    return '$name ya está desbloqueada.';
  }

  @override
  String get takeQuiz => 'Hacer el cuestionario';

  @override
  String get later => 'Más tarde';

  @override
  String get wordByWord => 'Palabra por palabra';

  @override
  String get quranSource =>
      'Texto del mus\'haf y palabra por palabra: quran.com (escritura uthmani del Complejo Rey Fahd) · Traducción: Sheij Isa García';

  @override
  String get startHere => 'INICIO';

  @override
  String get quizWordMeaning => '¿Qué significa esta palabra?';

  @override
  String get quizAyahMeaning => '¿Qué significa esta aleya?';

  @override
  String get quizWhichSurah => '¿De qué sura es esta aleya?';

  @override
  String quizRevealed(String name) {
    return '¿Dónde fue revelada la sura $name?';
  }

  @override
  String get makkah => 'La Meca';

  @override
  String get madinah => 'Medina';

  @override
  String quizVerses(String name) {
    return '¿Cuántas aleyas tiene la sura $name?';
  }

  @override
  String quizNameMeans(String name) {
    return '¿Qué significa el nombre “$name”?';
  }

  @override
  String get kindVocabulary => 'VOCABULARIO';

  @override
  String get kindMeaning => 'SIGNIFICADO';

  @override
  String get kindSurah => 'QUÉ SURA';

  @override
  String get kindFacts => 'DATOS DE LA SURA';

  @override
  String get quizCorrect => '¡Correcto, MashaAllah!';

  @override
  String get quizWrong =>
      'No exactamente: la respuesta correcta está resaltada.';

  @override
  String get continueBtn => 'Continuar';

  @override
  String quizScore(String score) {
    return 'Has obtenido un $score %';
  }

  @override
  String get quizDoneBody =>
      'Los cuestionarios son opcionales: te ayudan a recordar lo que lees.';

  @override
  String get quizLoading => 'Preparando tu cuestionario…';

  @override
  String get tabQuran => 'Corán';

  @override
  String get tabDua => 'Dua';

  @override
  String get specialSurahs => 'Recomendadas para leer';

  @override
  String get chipMulk => 'Al-Mulk';

  @override
  String get chipMulkWhen => 'Antes de dormir';

  @override
  String get chipSajdah => 'As-Sayda';

  @override
  String get chipKahf => 'Al-Kahf';

  @override
  String get chipKahfWhen => 'Viernes';

  @override
  String get chipKursi => 'Ayat al-Kursi';

  @override
  String get chipKursiWhen => 'Tras el salat y al dormir';

  @override
  String get chipBaqarahEnd => 'Últimas 2 de Al-Baqara';

  @override
  String get chipNight => 'Por la noche';

  @override
  String get chipYasin => 'Ya-Sin';

  @override
  String get chipQuls => 'Los 3 Qul';

  @override
  String get chipQulsWhen => 'Mañana y tarde';

  @override
  String get chipAnytime => 'En cualquier momento';

  @override
  String get chipToday => 'Hoy';

  @override
  String get chipTonight => 'Esta noche';

  @override
  String get revealedMakkah => 'Revelada en La Meca';

  @override
  String get revealedMadinah => 'Revelada en Medina';

  @override
  String get reciter => 'Recitador';

  @override
  String get chooseReciter => 'Elige un recitador';

  @override
  String get playAyah => 'Reproducir desde esta aleya';

  @override
  String recitingAyah(String n, String total) {
    return 'Aleya $n de $total';
  }

  @override
  String get audioError =>
      'No se pudo cargar la recitación. Comprueba tu internet.';

  @override
  String get dailyQuran => 'Corán diario';

  @override
  String get energy0 => 'Tu corazón espera luz hoy';

  @override
  String get energy1 => 'Cargando… unas aleyas más';

  @override
  String get energy2 => 'Casi lleno, ¡sigue!';

  @override
  String get energy3 => 'Lleno de luz, ¡MashaAllah!';

  @override
  String get energy4 => 'Brillando hoy ✨';

  @override
  String versesToday(String n, String goal) {
    return '$n / $goal aleyas hoy';
  }

  @override
  String streakDays(String n) {
    return 'Racha de $n días';
  }

  @override
  String get readNow => 'Leer ahora';

  @override
  String get keepReading => 'Leer más';

  @override
  String get achievements => 'Logros';

  @override
  String achievementsCount(String n, String total) {
    return '$n de $total conseguidos';
  }

  @override
  String achievementEarned(String date) {
    return 'Conseguido el $date';
  }

  @override
  String achievementLocked(String done, String target) {
    return 'En curso · $done/$target';
  }

  @override
  String achievementUnlocked(String name) {
    return 'Logro desbloqueado: $name';
  }

  @override
  String get ach_bismillah => 'Bismillah';

  @override
  String get ach_bismillah_desc => 'Lee tu primera aleya';

  @override
  String get ach_fatiha => 'La Apertura';

  @override
  String get ach_fatiha_desc => 'Termina la sura Al-Fatiha';

  @override
  String get ach_quls => 'Los tres Qul';

  @override
  String get ach_quls_desc => 'Termina Al-Ijlas, Al-Falaq y An-Nas';

  @override
  String get ach_streak3 => 'Pasos firmes';

  @override
  String get ach_streak3_desc => 'Lee el Corán 3 días seguidos';

  @override
  String get ach_streak7 => 'Semana de luz';

  @override
  String get ach_streak7_desc => 'Lee el Corán 7 días seguidos';

  @override
  String get ach_streak30 => 'Mes de Nur';

  @override
  String get ach_streak30_desc => 'Lee el Corán 30 días seguidos';

  @override
  String get ach_verses100 => 'Cien aleyas';

  @override
  String get ach_verses100_desc => 'Lee 100 aleyas';

  @override
  String get ach_verses1000 => 'Mil aleyas';

  @override
  String get ach_verses1000_desc => 'Lee 1000 aleyas';

  @override
  String get ach_kahf => 'Luz del viernes';

  @override
  String get ach_kahf_desc => 'Termina Al-Kahf un viernes';

  @override
  String get ach_mulk => 'Guardián de la noche';

  @override
  String get ach_mulk_desc => 'Termina Al-Mulk por la noche';

  @override
  String get ach_yasin => 'Ya-Sin';

  @override
  String get ach_yasin_desc => 'Termina la sura Ya-Sin';

  @override
  String get ach_listener => 'Oyente atento';

  @override
  String get ach_listener_desc => 'Escucha la recitación de una sura completa';

  @override
  String get ach_quiz100 => 'Mente aguda';

  @override
  String get ach_quiz100_desc => 'Saca un 100 % en un cuestionario de etapa';

  @override
  String get ach_juzamma => 'Yuz \'Amma';

  @override
  String get ach_juzamma_desc => 'Termina las 37 suras del yuz 30';

  @override
  String get ach_phases10 => 'Diez etapas';

  @override
  String get ach_phases10_desc => 'Completa 10 etapas del recorrido';

  @override
  String get ach_khatm => 'Jatm del Corán';

  @override
  String get ach_khatm_desc => 'Termina las 114 suras';

  @override
  String get duaHeader => 'Un día con el recuerdo de Allah';

  @override
  String get duaSub =>
      'De despertar a dormir: las súplicas que el Profeta ﷺ enseñó para cada momento.';

  @override
  String repeatTimes(String n) {
    return 'Di $n×';
  }

  @override
  String duaSource(String n) {
    return 'Hisn al-Muslim n.º $n';
  }

  @override
  String get duaCredit =>
      'Súplicas de Hisn al-Muslim (La Fortaleza del Musulmán) de Sa\'id bin Ali al-Qahtani, a través de su web oficial hisnmuslim.com. La traducción está en inglés.';

  @override
  String get nowLabel => 'Ahora';

  @override
  String get scene_wake => 'Al despertar';

  @override
  String get scene_wake_story =>
      'El día empieza dando gracias: Allah devolvió el alma tras el sueño.';

  @override
  String get scene_restroom => 'Al ir al baño';

  @override
  String get scene_restroom_story =>
      'Hasta la rutina más pequeña empieza pidiendo la protección de Allah.';

  @override
  String get scene_wudu => 'Wudu';

  @override
  String get scene_wudu_story =>
      'Agua en las manos, Su nombre en la lengua: preparándote para estar ante Allah.';

  @override
  String get scene_dress => 'Al vestirse';

  @override
  String get scene_dress_story =>
      'Cada prenda es un regalo: agradece a Quien te vistió.';

  @override
  String get scene_athan => 'El adhan';

  @override
  String get scene_athan_story =>
      'La llamada se eleva sobre el barrio: respóndela y luego pide por el Profeta ﷺ.';

  @override
  String get scene_masjid => 'Hacia la mezquita';

  @override
  String get scene_masjid_story =>
      'Cada paso hacia la mezquita es luz: entra y sal con una súplica.';

  @override
  String get scene_after_salah => 'Después del salat';

  @override
  String get scene_after_salah_story =>
      'Antes de irte deprisa, siéntate un momento con el recuerdo tras el salat.';

  @override
  String get scene_morning => 'Adhkar de la mañana';

  @override
  String get scene_morning_story => 'Palabras que te protegen hasta la tarde.';

  @override
  String get scene_eating => 'Desayuno';

  @override
  String get scene_eating_story =>
      'Empieza con Su nombre, termina con Su alabanza.';

  @override
  String get scene_leave_home => 'Al salir de casa';

  @override
  String get scene_leave_home_story =>
      'En la puerta, encomienda tu día a Allah.';

  @override
  String get scene_travel => 'En el camino';

  @override
  String get scene_travel_story =>
      'Autobús, rickshaw o coche: Allahu Akbar al subir, SubhanAllah al bajar.';

  @override
  String get scene_meeting => 'Al encontrarse con la gente';

  @override
  String get scene_meeting_story =>
      'Difunde el salam y responde al estornudo de tu hermano.';

  @override
  String get scene_good_news => 'Cuando ocurre algo bueno';

  @override
  String get scene_good_news_story =>
      'La alegría recuerda al Dador: alábale y agradece también a la gente.';

  @override
  String get scene_hardship => 'En la dificultad';

  @override
  String get scene_hardship_story =>
      'Preocupación, dificultad o un plan fallido: vuélvete primero a Él.';

  @override
  String get scene_patience => 'Pérdida y paciencia';

  @override
  String get scene_patience_story =>
      'Cuando algo te es quitado, recuerda que pertenecemos a Allah.';

  @override
  String get scene_anger => 'Contener la ira';

  @override
  String get scene_anger_story =>
      'Busca refugio antes de decir algo de lo que te arrepientas.';

  @override
  String get scene_pain => 'Dolor y enfermedad';

  @override
  String get scene_pain_story =>
      'Por tu propio dolor y por el amigo al que visitas.';

  @override
  String get scene_rain => 'Cuando llueve';

  @override
  String get scene_rain_story =>
      'La lluvia es misericordia: pide que sea beneficiosa.';

  @override
  String get scene_home => 'De vuelta a casa';

  @override
  String get scene_home_story => 'Entra con Su nombre y saluda a tu familia.';

  @override
  String get scene_gathering => 'Al dejar una reunión';

  @override
  String get scene_gathering_story =>
      'Antes de levantarte, borra los deslices de la lengua.';

  @override
  String get scene_forgiveness => 'Pedir perdón';

  @override
  String get scene_forgiveness_story =>
      'Los errores del día, lavados con istigfar.';

  @override
  String get scene_sleep => 'Antes de dormir';

  @override
  String get scene_sleep_story =>
      'Termina el día como empezó: en Su nombre, bajo Su protección.';

  @override
  String get scene_night => 'Por la noche';

  @override
  String get scene_night_story =>
      'Si te despiertas o tienes un mal sueño, Él está cerca.';

  @override
  String get part_dawn => 'Alba';

  @override
  String get part_morning => 'Mañana';

  @override
  String get part_day => 'Día';

  @override
  String get part_evening => 'Tarde';

  @override
  String get part_night => 'Noche';

  @override
  String get removeSession => 'Quitar';

  @override
  String addSession(String session) {
    return 'Añadir $session';
  }

  @override
  String get duaSearchHint => 'Buscar súplicas';

  @override
  String duaPartCount(String topics, String duas) {
    return '$topics temas · $duas súplicas';
  }

  @override
  String duaNoResults(String q) {
    return 'No hay súplicas para “$q”';
  }

  @override
  String duaResults(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString súplicas encontradas',
      one: '1 súplica encontrada',
    );
    return '$_temp0';
  }

  @override
  String get part_dawn_sub => 'Despertar, wudu y Fayr';

  @override
  String get part_morning_sub => 'Adhkar, comida y salir';

  @override
  String get part_day_sub => 'Gente, alegrías y pruebas';

  @override
  String get part_evening_sub => 'Casa, reuniones, istigfar';

  @override
  String get part_night_sub => 'El sueño y la noche';

  @override
  String duaCount(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString súplicas',
      one: '1 súplica',
    );
    return '$_temp0';
  }

  @override
  String get noticeSearchHint => 'Buscar avisos, mezquitas…';

  @override
  String get noticesSub => 'De las mezquitas de tu zona';

  @override
  String get tabNotices => 'Avisos';

  @override
  String get chooseSurah => 'Ir a una sura';

  @override
  String get surahSearchHint => 'Busca una sura por nombre o número';

  @override
  String get previousSurah => 'Sura anterior';

  @override
  String get pickOnMapTitle => 'Elegir en el mapa';

  @override
  String get mapSearchHint => 'Busca una mezquita o una zona';

  @override
  String get useMyLocation => 'Mi ubicación';

  @override
  String get mapPickHint =>
      'Mueve el mapa para que el pin quede sobre la mezquita, toca un punto o toca el icono de una mezquita.';

  @override
  String get mapMoving => 'Buscando el lugar…';

  @override
  String get useThisLocation => 'Usar esta ubicación';

  @override
  String get masjidLocation => 'Ubicación de la mezquita';

  @override
  String get chooseLocationWay =>
      'Elige una forma de fijar la ubicación exacta:';

  @override
  String get atTheMasjid => 'Estoy en la mezquita';

  @override
  String get atTheMasjidBody =>
      'Usa el GPS del teléfono. Permanece dentro de la mezquita mientras carga.';

  @override
  String get onTheMap => 'Elegir en el mapa';

  @override
  String get onTheMapBody =>
      'Señala la mezquita en el mapa o toca una que ya aparezca.';

  @override
  String get locFromMap => 'Elegida en el mapa';

  @override
  String get locFromGps => 'GPS';

  @override
  String get locSaved => 'Ubicación guardada';

  @override
  String get useGpsInstead => 'Usar GPS';

  @override
  String get adjustOnMap => 'Ajustar en el mapa';

  @override
  String get allMasjids => 'Todas las mezquitas';

  @override
  String get nearestFirst => 'Las más cercanas primero';

  @override
  String get duaForNow => 'Súplicas para este momento';

  @override
  String get tabChannel => 'Canal';

  @override
  String get channelInviteTitle => 'Mantente cerca de tu imam y tu jatib';

  @override
  String get channelInviteHadith =>
      '“Buscar el conocimiento es una obligación para todo musulmán.” — Sunan Ibn Mayah 224';

  @override
  String get channelInviteBody =>
      'Todo musulmán debe aprender el fard \'ayn —lo esencial de la fe, la purificación, el salat y la vida diaria— y la mejor manera es bajo la guía de un sabio. Únete al canal de esta mezquita para recibir la orientación y los mensajes de su imam y su jatib, y acercarte más a la mezquita de tu barrio.';

  @override
  String get joinChannel => 'Unirse al canal';

  @override
  String get openChannel => 'Abrir canal';

  @override
  String get joinedChannel => 'Estás en el canal de esta mezquita';

  @override
  String get channelJoined =>
      'Te has unido. Recibirás los mensajes del imam y el jatib.';

  @override
  String get leaveChannel => 'Salir del canal';

  @override
  String get leaveChannelQ =>
      '¿Salir de este canal? Dejarás de recibir sus mensajes.';

  @override
  String get leave => 'Salir';

  @override
  String get channelEmpty => 'Aún no hay mensajes.';

  @override
  String get channelEmptyAdmin => 'Envía el primer mensaje a tus miembros.';

  @override
  String get channelReadOnly =>
      'Aquí solo publican el imam, el jatib y los administradores del canal.';

  @override
  String get messageHint => 'Escribe un mensaje…';

  @override
  String get send => 'Enviar';

  @override
  String get deleteMessageQ => '¿Eliminar este mensaje para todos?';

  @override
  String get members => 'Miembros';

  @override
  String get noMembers =>
      'Aún no se ha unido nadie. Invita a la gente de tu mezquita.';

  @override
  String get roleMember => 'Miembro';

  @override
  String get roleEditor => 'Editor';

  @override
  String get roleAdmin => 'Administrador';

  @override
  String get roleMemberDesc => 'Lee los mensajes';

  @override
  String get roleEditorDesc => 'Puede enviar mensajes';

  @override
  String get roleAdminDesc => 'Envía mensajes y gestiona los miembros';

  @override
  String get removeMember => 'Quitar del canal';

  @override
  String get you => 'Tú';

  @override
  String get channelMessages => 'Mensajes del canal';

  @override
  String get noticesHeading => 'Avisos';

  @override
  String get signInToJoin => 'Inicia sesión para unirte al canal.';

  @override
  String get monthNames =>
      'enero,febrero,marzo,abril,mayo,junio,julio,agosto,septiembre,octubre,noviembre,diciembre';

  @override
  String get am => 'a. m.';

  @override
  String get pm => 'p. m.';

  @override
  String jamatReminderBody(String prayer, String minutes) {
    return 'Yamaa de $prayer en $minutes minutos';
  }

  @override
  String get attach => 'Adjuntar';

  @override
  String get attachPhoto => 'Foto';

  @override
  String get attachVideo => 'Vídeo';

  @override
  String get attachAudio => 'Audio';

  @override
  String get attachFile => 'Archivo';

  @override
  String fileTooLarge(String size) {
    return 'El archivo es demasiado grande. El límite es $size.';
  }

  @override
  String get cantOpenFile =>
      'Ninguna app de este teléfono puede abrir este archivo.';

  @override
  String get channelNotAllowed =>
      'El canal no está disponible ahora (acceso denegado). Inténtalo más tarde.';

  @override
  String get duaForNowSub => 'Recuerdo y duas para esta hora del día';

  @override
  String get approxLocation =>
      'Ubicación aproximada – toca para activar la ubicación exacta';

  @override
  String get signInFirst => 'Primero inicia sesión.';

  @override
  String get volunteerTitleEmpty => 'Aún no hay horarios de jamaat';

  @override
  String get volunteerBodyEmpty =>
      '¿Vives o rezas cerca de esta mezquita? Añade sus horarios de jamaat y mantenlos al día para todos.';

  @override
  String get volunteerTitle => '¿Rezas aquí con frecuencia?';

  @override
  String get volunteerBody =>
      'Ayuda a que los horarios de jamaat de esta mezquita sean correctos.';

  @override
  String get volunteerButton => 'Quiero actualizar el horario';

  @override
  String get volunteerCheckTitle => 'Actualizar los horarios de esta mezquita';

  @override
  String volunteerCheckBody(String km) {
    return 'Quienes viven cerca de una mezquita pueden actualizar sus horarios. Comprobaremos que estás a menos de $km km – tu ubicación solo se usa para esta comprobación.';
  }

  @override
  String get volunteerCheckButton => 'Comprobar mi ubicación';

  @override
  String get volunteerChecking => 'Comprobando tu ubicación…';

  @override
  String volunteerTooFar(String distance, String km) {
    return 'Estás a $distance. Acércate a menos de $km km de la mezquita para actualizar sus horarios.';
  }

  @override
  String get volunteerApprox =>
      'Tu teléfono solo comparte una ubicación aproximada. Activa la ubicación exacta para Muslimin e inténtalo de nuevo.';

  @override
  String get volunteerBlocked =>
      'Ahora no puedes actualizar horarios. Contacta con el administrador si es un error.';

  @override
  String get volunteerWelcome =>
      '¡Gracias! Ya puedes actualizar los horarios de esta mezquita.';

  @override
  String get stopEditing => 'Dejar de actualizar esta mezquita';

  @override
  String get reportProblem => 'Informar de un problema';

  @override
  String get reportTitle => '¿Qué está mal?';

  @override
  String get reportWrongTime => 'Horario de jamaat incorrecto';

  @override
  String get reportWrongLocation => 'Ubicación incorrecta en el mapa';

  @override
  String get reportWrongInfo => 'Nombre o datos incorrectos';

  @override
  String get reportClosed => 'Cerrada o no existe';

  @override
  String get reportDuplicate => 'Aparece dos veces';

  @override
  String get reportOther => 'Otra cosa';

  @override
  String get reportNote => 'Detalles (opcional): p. ej. la hora correcta';

  @override
  String get reportSend => 'Enviar';

  @override
  String get reportThanks => 'Gracias: el administrador lo revisará.';

  @override
  String get volunteers => 'Editores voluntarios';

  @override
  String get noVolunteers => 'Aún no hay voluntarios.';

  @override
  String editorDistance(String distance) {
    return 'A $distance de la mezquita al unirse';
  }

  @override
  String get removeEditor => 'Quitar';

  @override
  String get removeAndBlock => 'Quitar y bloquear la edición';

  @override
  String lastUpdatedBy(String when, String name) {
    return 'Actualizado $when por $name';
  }

  @override
  String get adminReport => 'Informe';

  @override
  String get adminProblems => 'Problemas';

  @override
  String get adminEdits => 'Cambios';

  @override
  String get statMasjids => 'Mezquitas';

  @override
  String get statWithTimes => 'Con horarios';

  @override
  String get statVolunteers => 'Voluntarios';

  @override
  String get statOpenReports => 'Problemas abiertos';

  @override
  String get statPending => 'Pendientes de revisión';

  @override
  String get shareReport => 'Compartir informe';

  @override
  String get coverageTitle => 'Por distrito';

  @override
  String get coverageLoad => 'Mostrar distritos';

  @override
  String get resolve => 'Marcar resuelto';

  @override
  String get revert => 'Deshacer cambio';

  @override
  String get reverted => 'Cambio deshecho';

  @override
  String get editFieldStaff => 'Personal';

  @override
  String get editFieldMaktab => 'Maktab';

  @override
  String timeLooksWrong(String prayers) {
    return 'Estos horarios parecen incorrectos: $prayers. Revisa AM/PM.';
  }

  @override
  String get dataCredits =>
      'Ubicación de las mezquitas: © OpenStreetMap contributors (ODbL). Límites de distritos y upazilas: Oficina de Estadística de Bangladés / OCHA vía geoBoundaries (CC BY 3.0 IGO).';

  @override
  String get fromOsm =>
      'Añadida desde OpenStreetMap (© OpenStreetMap contributors). Los horarios los añaden vecinos.';

  @override
  String get jumuahNote => 'Los viernes, en lugar del Dhuhr';

  @override
  String get chooseThana => 'Elegir zona';

  @override
  String get chooseThanaHint =>
      'Muestra las mezquitas de esa zona; tu ubicación no cambia.';

  @override
  String get searchThana => 'Buscar zona o distrito';

  @override
  String get myThana => 'Donde estás ahora';

  @override
  String get missingMasjidTitle => '¿Falta una mezquita?';

  @override
  String get missingMasjidBody =>
      'Añade una mezquita cercana que no aparece: márcala en el mapa y pon su nombre.';

  @override
  String get addMissingMasjid => 'Añadir mezquita';

  @override
  String alreadyListed(String name) {
    return '\"$name\" ya está en este lugar.';
  }

  @override
  String get openIt => 'Abrir';

  @override
  String get addAnyway => 'Es otra mezquita';

  @override
  String get suggestReviewNote =>
      'El administrador la revisa antes de mostrarla. Una vez aprobada podrás añadir sus horarios.';

  @override
  String get suggestNameShort => 'Escribe el nombre de la mezquita.';

  @override
  String get suggestThanks => '¡Gracias! El administrador la añadirá pronto.';

  @override
  String get adminNewMasjids => 'Nuevas mezquitas';

  @override
  String get seeOnMap => 'Mapa';

  @override
  String get noMasjidInThana => 'Aún no hay mezquitas en esta zona.';

  @override
  String get allAreas => 'Todas las zonas';

  @override
  String get errorBusy => 'La app está muy ocupada ahora. Inténtalo más tarde.';

  @override
  String get errorNoAccess => 'No tienes acceso a esto.';

  @override
  String get errorOffline => 'Sin conexión a internet.';

  @override
  String get walk => 'A pie';

  @override
  String get drive => 'En coche';

  @override
  String get routeUnavailable => 'Ruta no disponible: distancia en línea recta';

  @override
  String get openInMapsApp => 'Abrir en la app de mapas';

  @override
  String minutesShort(String minutes) {
    return '$minutes min';
  }

  @override
  String hoursMinutes(String hours, String minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get fixLocation => '¿Ubicación errónea? Corregir';

  @override
  String get editFieldLocation => 'Ubicación';

  @override
  String get attachAnyFile => 'Archivo (vídeo, audio, PDF…)';

  @override
  String get speechUnavailable =>
      'La voz a texto no está disponible en este teléfono.';

  @override
  String get speechNothing =>
      'No se oyó nada: mantén pulsado el micro y habla.';

  @override
  String get holdToTalk => 'Mantén pulsado para hablar';

  @override
  String get listening => 'Escuchando…';

  @override
  String get slideToCancel => 'Desliza para cancelar';

  @override
  String get channelMembers => 'Miembros del canal';
}
