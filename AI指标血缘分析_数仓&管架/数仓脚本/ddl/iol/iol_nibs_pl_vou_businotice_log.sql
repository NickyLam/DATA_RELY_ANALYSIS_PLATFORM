/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_pl_vou_businotice_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_pl_vou_businotice_log
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_pl_vou_businotice_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_pl_vou_businotice_log(
    noticedate date -- 通知日期
    ,remark2 varchar2(100) -- 备用字段2
    ,channeldate date -- 渠道日期
    ,channelserno varchar2(60) -- 渠道流水
    ,channelcode varchar2(20) -- 渠道代码
    ,voutype varchar2(30) -- 凭证种类
    ,voukind varchar2(2) -- 凭证类型 0 客户签字凭证，1交易成功凭证
    ,scenecode varchar2(30) -- 第三方交易码
    ,noticestep varchar2(2) -- 处理步骤　01-进行pdf加签　02-上传归档平台 03 -已作废
    ,noticestatus varchar2(2) -- 处理标识 0-初始　1-成功　2-失败　3-处理中　4-处理异常
    ,procnum varchar2(3) -- 处理次数
    ,noticebatchno varchar2(100) -- 通知批次号
    ,genidflag varchar2(2) -- 归档号生成方式1-平台生成 2－渠道生成
    ,fileupstatus varchar2(2) -- 文件上传状态0-初始 1-上传成功 2-平台合成 3-平台处理中 4-处理异常 5-已作废
    ,filepath varchar2(200) -- 源文件路径
    ,sourcefilename varchar2(100) -- 源文件名
    ,aimfilename varchar2(100) -- 加密文件名
    ,aimcontentid varchar2(100) -- 影像批次号
    ,filesize varchar2(64) -- 文件大小标识
    ,orgid varchar2(12) -- 机构编号
    ,tellerid varchar2(8) -- 柜员编号
    ,oprdate date -- 操作日期
    ,printno varchar2(35) -- 打印流水号
    ,dealcode varchar2(20) -- 应用处理码
    ,dealmsg varchar2(2000) -- 应用处理信息
    ,crtdatetime date -- 创建时间
    ,altdatetime date -- 修改时间
    ,remark varchar2(300) -- 备用字段
    ,remark1 varchar2(50) -- 备用字段1
    ,noticeserno varchar2(64) -- 通知流水
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.nibs_pl_vou_businotice_log to ${iml_schema};
grant select on ${iol_schema}.nibs_pl_vou_businotice_log to ${icl_schema};
grant select on ${iol_schema}.nibs_pl_vou_businotice_log to ${idl_schema};
grant select on ${iol_schema}.nibs_pl_vou_businotice_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_pl_vou_businotice_log is '凭证待通知处理登记簿';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.noticedate is '通知日期';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.remark2 is '备用字段2';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.channeldate is '渠道日期';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.channelserno is '渠道流水';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.channelcode is '渠道代码';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.voutype is '凭证种类';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.voukind is '凭证类型 0 客户签字凭证，1交易成功凭证';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.scenecode is '第三方交易码';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.noticestep is '处理步骤　01-进行pdf加签　02-上传归档平台 03 -已作废';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.noticestatus is '处理标识 0-初始　1-成功　2-失败　3-处理中　4-处理异常';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.procnum is '处理次数';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.noticebatchno is '通知批次号';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.genidflag is '归档号生成方式1-平台生成 2－渠道生成';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.fileupstatus is '文件上传状态0-初始 1-上传成功 2-平台合成 3-平台处理中 4-处理异常 5-已作废';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.filepath is '源文件路径';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.sourcefilename is '源文件名';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.aimfilename is '加密文件名';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.aimcontentid is '影像批次号';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.filesize is '文件大小标识';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.orgid is '机构编号';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.tellerid is '柜员编号';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.oprdate is '操作日期';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.printno is '打印流水号';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.dealcode is '应用处理码';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.dealmsg is '应用处理信息';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.crtdatetime is '创建时间';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.altdatetime is '修改时间';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.remark is '备用字段';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.remark1 is '备用字段1';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.noticeserno is '通知流水';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_pl_vou_businotice_log.etl_timestamp is 'ETL处理时间戳';
