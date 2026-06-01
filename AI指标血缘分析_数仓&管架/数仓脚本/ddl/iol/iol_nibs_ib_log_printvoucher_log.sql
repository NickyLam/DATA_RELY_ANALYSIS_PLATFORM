/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_log_printvoucher_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_log_printvoucher_log
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_log_printvoucher_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_log_printvoucher_log(
    pr_sn varchar2(16) -- 机构名
    ,chan_num varchar2(6) -- 用户编号
    ,tx_seq_num varchar2(33) -- 用户名称
    ,channeltrancode varchar2(32) -- 柜员号
    ,channeltranname varchar2(128) -- 设备型号
    ,nodecode varchar2(32) -- 设备编号
    ,tx_dt date -- 交易码
    ,backrspdate date -- 交易名称
    ,vouchertype varchar2(1) -- 交易日期
    ,vouchername varchar2(64) -- 交易时间
    ,iselecseal varchar2(1) -- 服务流水
    ,elecsealnum varchar2(20) -- 受理流水
    ,isprtcontrol varchar2(1) -- 包流水
    ,prtcontrolnum varchar2(20) -- 核心日期
    ,prtseqno varchar2(20) -- 核心时间
    ,prtnum number(5,0) -- 通讯流水
    ,prtdate date -- ip
    ,prtbranch varchar2(12) -- oid
    ,prtreason varchar2(128) -- 后台流水
    ,prtmsg varchar2(4000) -- 交易状态
    ,print_telr_no varchar2(8) -- 返回码
    ,prompt varchar2(128) -- 返回描述
    ,rprint_telr_no varchar2(8) -- 交易路径
    ,rprint_dt date -- 交易数据
    ,rprint_tms number(5,0) -- 任务id
    ,rprint_auth_telr_no varchar2(8) -- 影像id
    ,rprint_typ_cd varchar2(1) -- 客户类型
    ,rprint_rsn varchar2(100) -- 客户号
    ,note1 varchar2(512) -- 证件类型
    ,note2 varchar2(512) -- 证件号
    ,blendingstatu varchar2(1) -- 勾兑状态 0-未勾兑、1-已勾兑，2-勾兑失败，3-无需勾兑，5-处理中
    ,blendingtype varchar2(1) -- 勾兑方式 0-手动，1-自动
    ,blip_id varchar2(255) -- 影像编号
    ,prttype varchar2(20) -- 打印类型|
    ,app_num varchar2(10) -- 
    ,blendingdesc varchar2(1024) -- 
    ,blip_seq varchar2(255) -- 
    ,cheanflag varchar2(10) -- 
    ,sealtype varchar2(100) -- 印章类型
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
grant select on ${iol_schema}.nibs_ib_log_printvoucher_log to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_log_printvoucher_log to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_log_printvoucher_log to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_log_printvoucher_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_log_printvoucher_log is '打印凭证日志表';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.pr_sn is '机构名';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.chan_num is '用户编号';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.tx_seq_num is '用户名称';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.channeltrancode is '柜员号';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.channeltranname is '设备型号';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.nodecode is '设备编号';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.tx_dt is '交易码';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.backrspdate is '交易名称';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.vouchertype is '交易日期';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.vouchername is '交易时间';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.iselecseal is '服务流水';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.elecsealnum is '受理流水';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.isprtcontrol is '包流水';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.prtcontrolnum is '核心日期';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.prtseqno is '核心时间';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.prtnum is '通讯流水';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.prtdate is 'ip';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.prtbranch is 'oid';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.prtreason is '后台流水';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.prtmsg is '交易状态';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.print_telr_no is '返回码';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.prompt is '返回描述';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.rprint_telr_no is '交易路径';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.rprint_dt is '交易数据';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.rprint_tms is '任务id';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.rprint_auth_telr_no is '影像id';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.rprint_typ_cd is '客户类型';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.rprint_rsn is '客户号';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.note1 is '证件类型';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.note2 is '证件号';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.blendingstatu is '勾兑状态 0-未勾兑、1-已勾兑，2-勾兑失败，3-无需勾兑，5-处理中';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.blendingtype is '勾兑方式 0-手动，1-自动';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.blip_id is '影像编号';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.prttype is '打印类型|';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.app_num is '';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.blendingdesc is '';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.blip_seq is '';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.cheanflag is '';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.sealtype is '印章类型';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.start_dt is '开始时间';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.end_dt is '结束时间';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.id_mark is '增删标志';
comment on column ${iol_schema}.nibs_ib_log_printvoucher_log.etl_timestamp is 'ETL处理时间戳';
