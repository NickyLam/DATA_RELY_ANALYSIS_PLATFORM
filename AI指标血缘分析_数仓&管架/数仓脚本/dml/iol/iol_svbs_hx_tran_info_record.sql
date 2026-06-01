/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_svbs_hx_tran_info_record
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.svbs_hx_tran_info_record_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.svbs_hx_tran_info_record
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.svbs_hx_tran_info_record_op purge;
drop table ${iol_schema}.svbs_hx_tran_info_record_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.svbs_hx_tran_info_record_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.svbs_hx_tran_info_record where 0=1;

create table ${iol_schema}.svbs_hx_tran_info_record_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.svbs_hx_tran_info_record where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.svbs_hx_tran_info_record_cl(
            sessionid -- 会话ID
            ,billid -- 订单号
            ,glob_seq_num -- 全局流水号
            ,status -- 1-生成二维码，2-正在双录，4-完成双录，5-影像下载失败 6- 影像下载成功 7-影像上传失败 8-影像上传成功 9-通知关联系统失败 10-通知关联系统成功 11-双录完成通知外系统失败 12-双录完成通知外系统成功  13-异常中断
            ,tran_code -- 交易码
            ,channel_type -- 发起渠道 1-移动作业平台(PAD)，2-兴金融小程序，3-手机银行（安卓），4-手机银行（IOS），5-企业手机银行（安卓），6-企业手机银行（IOS）
            ,system_sign -- 系统标识
            ,qrcode -- 小程序二维码base64
            ,create_date -- 创建日期
            ,update_date -- 最后更新日期
            ,delete_flag -- 删除标识 0- 使用中 1-已删除
            ,notes -- 备注
            ,is_tts -- 是否开启语音播报， 0-关闭  1-开启
            ,is_asr -- 是否开启语音识别， 0-关闭  1-开启
            ,video_duration -- 视频时长，单位毫秒
            ,video_duration_str -- 视频时长字符串，格式00:00:00.00
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.svbs_hx_tran_info_record_op(
            sessionid -- 会话ID
            ,billid -- 订单号
            ,glob_seq_num -- 全局流水号
            ,status -- 1-生成二维码，2-正在双录，4-完成双录，5-影像下载失败 6- 影像下载成功 7-影像上传失败 8-影像上传成功 9-通知关联系统失败 10-通知关联系统成功 11-双录完成通知外系统失败 12-双录完成通知外系统成功  13-异常中断
            ,tran_code -- 交易码
            ,channel_type -- 发起渠道 1-移动作业平台(PAD)，2-兴金融小程序，3-手机银行（安卓），4-手机银行（IOS），5-企业手机银行（安卓），6-企业手机银行（IOS）
            ,system_sign -- 系统标识
            ,qrcode -- 小程序二维码base64
            ,create_date -- 创建日期
            ,update_date -- 最后更新日期
            ,delete_flag -- 删除标识 0- 使用中 1-已删除
            ,notes -- 备注
            ,is_tts -- 是否开启语音播报， 0-关闭  1-开启
            ,is_asr -- 是否开启语音识别， 0-关闭  1-开启
            ,video_duration -- 视频时长，单位毫秒
            ,video_duration_str -- 视频时长字符串，格式00:00:00.00
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sessionid, o.sessionid) as sessionid -- 会话ID
    ,nvl(n.billid, o.billid) as billid -- 订单号
    ,nvl(n.glob_seq_num, o.glob_seq_num) as glob_seq_num -- 全局流水号
    ,nvl(n.status, o.status) as status -- 1-生成二维码，2-正在双录，4-完成双录，5-影像下载失败 6- 影像下载成功 7-影像上传失败 8-影像上传成功 9-通知关联系统失败 10-通知关联系统成功 11-双录完成通知外系统失败 12-双录完成通知外系统成功  13-异常中断
    ,nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.channel_type, o.channel_type) as channel_type -- 发起渠道 1-移动作业平台(PAD)，2-兴金融小程序，3-手机银行（安卓），4-手机银行（IOS），5-企业手机银行（安卓），6-企业手机银行（IOS）
    ,nvl(n.system_sign, o.system_sign) as system_sign -- 系统标识
    ,nvl(n.qrcode, o.qrcode) as qrcode -- 小程序二维码base64
    ,nvl(n.create_date, o.create_date) as create_date -- 创建日期
    ,nvl(n.update_date, o.update_date) as update_date -- 最后更新日期
    ,nvl(n.delete_flag, o.delete_flag) as delete_flag -- 删除标识 0- 使用中 1-已删除
    ,nvl(n.notes, o.notes) as notes -- 备注
    ,nvl(n.is_tts, o.is_tts) as is_tts -- 是否开启语音播报， 0-关闭  1-开启
    ,nvl(n.is_asr, o.is_asr) as is_asr -- 是否开启语音识别， 0-关闭  1-开启
    ,nvl(n.video_duration, o.video_duration) as video_duration -- 视频时长，单位毫秒
    ,nvl(n.video_duration_str, o.video_duration_str) as video_duration_str -- 视频时长字符串，格式00:00:00.00
    ,case when
            n.sessionid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sessionid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sessionid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.svbs_hx_tran_info_record_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.svbs_hx_tran_info_record where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sessionid = n.sessionid
where (
        o.sessionid is null
    )
    or (
        n.sessionid is null
    )
    or (
        o.billid <> n.billid
        or o.glob_seq_num <> n.glob_seq_num
        or o.status <> n.status
        or o.tran_code <> n.tran_code
        or o.channel_type <> n.channel_type
        or o.system_sign <> n.system_sign
        or o.qrcode <> n.qrcode
        or o.create_date <> n.create_date
        or o.update_date <> n.update_date
        or o.delete_flag <> n.delete_flag
        or o.notes <> n.notes
        or o.is_tts <> n.is_tts
        or o.is_asr <> n.is_asr
        or o.video_duration <> n.video_duration
        or o.video_duration_str <> n.video_duration_str
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.svbs_hx_tran_info_record_cl(
            sessionid -- 会话ID
            ,billid -- 订单号
            ,glob_seq_num -- 全局流水号
            ,status -- 1-生成二维码，2-正在双录，4-完成双录，5-影像下载失败 6- 影像下载成功 7-影像上传失败 8-影像上传成功 9-通知关联系统失败 10-通知关联系统成功 11-双录完成通知外系统失败 12-双录完成通知外系统成功  13-异常中断
            ,tran_code -- 交易码
            ,channel_type -- 发起渠道 1-移动作业平台(PAD)，2-兴金融小程序，3-手机银行（安卓），4-手机银行（IOS），5-企业手机银行（安卓），6-企业手机银行（IOS）
            ,system_sign -- 系统标识
            ,qrcode -- 小程序二维码base64
            ,create_date -- 创建日期
            ,update_date -- 最后更新日期
            ,delete_flag -- 删除标识 0- 使用中 1-已删除
            ,notes -- 备注
            ,is_tts -- 是否开启语音播报， 0-关闭  1-开启
            ,is_asr -- 是否开启语音识别， 0-关闭  1-开启
            ,video_duration -- 视频时长，单位毫秒
            ,video_duration_str -- 视频时长字符串，格式00:00:00.00
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.svbs_hx_tran_info_record_op(
            sessionid -- 会话ID
            ,billid -- 订单号
            ,glob_seq_num -- 全局流水号
            ,status -- 1-生成二维码，2-正在双录，4-完成双录，5-影像下载失败 6- 影像下载成功 7-影像上传失败 8-影像上传成功 9-通知关联系统失败 10-通知关联系统成功 11-双录完成通知外系统失败 12-双录完成通知外系统成功  13-异常中断
            ,tran_code -- 交易码
            ,channel_type -- 发起渠道 1-移动作业平台(PAD)，2-兴金融小程序，3-手机银行（安卓），4-手机银行（IOS），5-企业手机银行（安卓），6-企业手机银行（IOS）
            ,system_sign -- 系统标识
            ,qrcode -- 小程序二维码base64
            ,create_date -- 创建日期
            ,update_date -- 最后更新日期
            ,delete_flag -- 删除标识 0- 使用中 1-已删除
            ,notes -- 备注
            ,is_tts -- 是否开启语音播报， 0-关闭  1-开启
            ,is_asr -- 是否开启语音识别， 0-关闭  1-开启
            ,video_duration -- 视频时长，单位毫秒
            ,video_duration_str -- 视频时长字符串，格式00:00:00.00
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sessionid -- 会话ID
    ,o.billid -- 订单号
    ,o.glob_seq_num -- 全局流水号
    ,o.status -- 1-生成二维码，2-正在双录，4-完成双录，5-影像下载失败 6- 影像下载成功 7-影像上传失败 8-影像上传成功 9-通知关联系统失败 10-通知关联系统成功 11-双录完成通知外系统失败 12-双录完成通知外系统成功  13-异常中断
    ,o.tran_code -- 交易码
    ,o.channel_type -- 发起渠道 1-移动作业平台(PAD)，2-兴金融小程序，3-手机银行（安卓），4-手机银行（IOS），5-企业手机银行（安卓），6-企业手机银行（IOS）
    ,o.system_sign -- 系统标识
    ,o.qrcode -- 小程序二维码base64
    ,o.create_date -- 创建日期
    ,o.update_date -- 最后更新日期
    ,o.delete_flag -- 删除标识 0- 使用中 1-已删除
    ,o.notes -- 备注
    ,o.is_tts -- 是否开启语音播报， 0-关闭  1-开启
    ,o.is_asr -- 是否开启语音识别， 0-关闭  1-开启
    ,o.video_duration -- 视频时长，单位毫秒
    ,o.video_duration_str -- 视频时长字符串，格式00:00:00.00
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.svbs_hx_tran_info_record_bk o
    left join ${iol_schema}.svbs_hx_tran_info_record_op n
        on
            o.sessionid = n.sessionid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.svbs_hx_tran_info_record_cl d
        on
            o.sessionid = d.sessionid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.svbs_hx_tran_info_record;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('svbs_hx_tran_info_record') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.svbs_hx_tran_info_record drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.svbs_hx_tran_info_record add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.svbs_hx_tran_info_record exchange partition p_${batch_date} with table ${iol_schema}.svbs_hx_tran_info_record_cl;
alter table ${iol_schema}.svbs_hx_tran_info_record exchange partition p_20991231 with table ${iol_schema}.svbs_hx_tran_info_record_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.svbs_hx_tran_info_record to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.svbs_hx_tran_info_record_op purge;
drop table ${iol_schema}.svbs_hx_tran_info_record_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.svbs_hx_tran_info_record_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'svbs_hx_tran_info_record',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
