/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol svbs_hx_tran_info_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.svbs_hx_tran_info_record
whenever sqlerror continue none;
drop table ${iol_schema}.svbs_hx_tran_info_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.svbs_hx_tran_info_record(
    sessionid varchar2(75) -- 会话ID
    ,billid varchar2(75) -- 订单号
    ,glob_seq_num varchar2(75) -- 全局流水号
    ,status number -- 1-生成二维码，2-正在双录，4-完成双录，5-影像下载失败 6- 影像下载成功 7-影像上传失败 8-影像上传成功 9-通知关联系统失败 10-通知关联系统成功 11-双录完成通知外系统失败 12-双录完成通知外系统成功  13-异常中断
    ,tran_code varchar2(200) -- 交易码
    ,channel_type number -- 发起渠道 1-移动作业平台(PAD)，2-兴金融小程序，3-手机银行（安卓），4-手机银行（IOS），5-企业手机银行（安卓），6-企业手机银行（IOS）
    ,system_sign varchar2(512) -- 系统标识
    ,qrcode varchar2(4000) -- 小程序二维码base64
    ,create_date date -- 创建日期
    ,update_date date -- 最后更新日期
    ,delete_flag number -- 删除标识 0- 使用中 1-已删除
    ,notes varchar2(300) -- 备注
    ,is_tts varchar2(2) -- 是否开启语音播报， 0-关闭  1-开启
    ,is_asr varchar2(2) -- 是否开启语音识别， 0-关闭  1-开启
    ,video_duration number -- 视频时长，单位毫秒
    ,video_duration_str varchar2(150) -- 视频时长字符串，格式00:00:00.00
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.svbs_hx_tran_info_record to ${iml_schema};
grant select on ${iol_schema}.svbs_hx_tran_info_record to ${icl_schema};
grant select on ${iol_schema}.svbs_hx_tran_info_record to ${idl_schema};
grant select on ${iol_schema}.svbs_hx_tran_info_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.svbs_hx_tran_info_record is '交易状态记录表';
comment on column ${iol_schema}.svbs_hx_tran_info_record.sessionid is '会话ID';
comment on column ${iol_schema}.svbs_hx_tran_info_record.billid is '订单号';
comment on column ${iol_schema}.svbs_hx_tran_info_record.glob_seq_num is '全局流水号';
comment on column ${iol_schema}.svbs_hx_tran_info_record.status is '1-生成二维码，2-正在双录，4-完成双录，5-影像下载失败 6- 影像下载成功 7-影像上传失败 8-影像上传成功 9-通知关联系统失败 10-通知关联系统成功 11-双录完成通知外系统失败 12-双录完成通知外系统成功  13-异常中断';
comment on column ${iol_schema}.svbs_hx_tran_info_record.tran_code is '交易码';
comment on column ${iol_schema}.svbs_hx_tran_info_record.channel_type is '发起渠道 1-移动作业平台(PAD)，2-兴金融小程序，3-手机银行（安卓），4-手机银行（IOS），5-企业手机银行（安卓），6-企业手机银行（IOS）';
comment on column ${iol_schema}.svbs_hx_tran_info_record.system_sign is '系统标识';
comment on column ${iol_schema}.svbs_hx_tran_info_record.qrcode is '小程序二维码base64';
comment on column ${iol_schema}.svbs_hx_tran_info_record.create_date is '创建日期';
comment on column ${iol_schema}.svbs_hx_tran_info_record.update_date is '最后更新日期';
comment on column ${iol_schema}.svbs_hx_tran_info_record.delete_flag is '删除标识 0- 使用中 1-已删除';
comment on column ${iol_schema}.svbs_hx_tran_info_record.notes is '备注';
comment on column ${iol_schema}.svbs_hx_tran_info_record.is_tts is '是否开启语音播报， 0-关闭  1-开启';
comment on column ${iol_schema}.svbs_hx_tran_info_record.is_asr is '是否开启语音识别， 0-关闭  1-开启';
comment on column ${iol_schema}.svbs_hx_tran_info_record.video_duration is '视频时长，单位毫秒';
comment on column ${iol_schema}.svbs_hx_tran_info_record.video_duration_str is '视频时长字符串，格式00:00:00.00';
comment on column ${iol_schema}.svbs_hx_tran_info_record.start_dt is '开始时间';
comment on column ${iol_schema}.svbs_hx_tran_info_record.end_dt is '结束时间';
comment on column ${iol_schema}.svbs_hx_tran_info_record.id_mark is '增删标志';
comment on column ${iol_schema}.svbs_hx_tran_info_record.etl_timestamp is 'ETL处理时间戳';
