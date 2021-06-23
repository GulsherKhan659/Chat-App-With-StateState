import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';


class FormatDate{
    static converTimestampToDateTime({Timestamp? timeStamp}){
        final _date= timeStamp!.toDate();
        ///print(date.format(DateTimeFormats.american));
        final _formatTimeStampdate= DateTimeFormat.format(_date, format: DateTimeFormats.american);
        return _formatTimeStampdate;
    }

    static converTimestampToTime({Timestamp? timeStamp}){
        final _date= timeStamp!.toDate();
        ///print(date.format(DateTimeFormats.american));
        final _formatTimeStampdate= DateTimeFormat.format(_date, format: ' h:i A');
        return _formatTimeStampdate;
    }
}
