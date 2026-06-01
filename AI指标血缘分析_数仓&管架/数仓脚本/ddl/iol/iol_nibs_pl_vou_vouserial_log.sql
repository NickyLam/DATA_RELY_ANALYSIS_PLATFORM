/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_pl_vou_vouserial_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_pl_vou_vouserial_log
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_pl_vou_vouserial_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_pl_vou_vouserial_log(
    elecdocdate date -- 电子凭证日期
    ,remark2 varchar2(60) -- 备注2
    ,elecdockind varchar2(2) -- 1-第三方联机网银模式,2-第三方联机自助设备模式,3-第三方控件形态，4-日终批量 5-第三方联机网贷模式
    ,elecdoctime date -- 电子凭证生成时间
    ,chanelcode varchar2(6) -- 交易渠道编号
    ,chaneldate date -- 渠道日期
    ,chaneltime date -- 渠道时间
    ,printno varchar2(64) -- 渠道打印流水号（关联各系统自己的凭证打印）
    ,hostserialno varchar2(64) -- 主机流水号
    ,tradecode varchar2(10) -- 交易码
    ,tradename varchar2(60) -- 交易名称
    ,oprbranch varchar2(12) -- 操作机构编号
    ,oprteller varchar2(8) -- 操作柜员编号
    ,voutype varchar2(30) -- 凭证种类
    ,vouname varchar2(60) -- 凭证名称
    ,scenecode varchar2(30) -- 场景码
    ,content varchar2(4000) -- 打印信息主联
    ,content1 varchar2(4000) -- 打印信息副联
    ,voumodelid varchar2(30) -- 电子凭证id号
    ,vousaveid varchar2(30) -- 电子凭证归档号
    ,genidflag varchar2(2) -- 归档号生成方式1-平台生成 2－渠道生成
    ,status varchar2(2) -- 凭证状态 1-正常 4-作废
    ,userconfirmflg varchar2(2) -- 用户确认方式（0-签名、1-指纹）
    ,userconfirmdata varchar2(4000) -- 用户确认数据
    ,fileuserinfo varchar2(100) -- 归档文件用户信息,相关字段以@@分隔
    ,remark varchar2(60) -- 备注
    ,remark1 varchar2(60) -- 备注1
    ,elecdocno varchar2(64) -- 电子凭证流水号
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
grant select on ${iol_schema}.nibs_pl_vou_vouserial_log to ${iml_schema};
grant select on ${iol_schema}.nibs_pl_vou_vouserial_log to ${icl_schema};
grant select on ${iol_schema}.nibs_pl_vou_vouserial_log to ${idl_schema};
grant select on ${iol_schema}.nibs_pl_vou_vouserial_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_pl_vou_vouserial_log is '电子凭证流水表';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.elecdocdate is '电子凭证日期';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.remark2 is '备注2';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.elecdockind is '1-第三方联机网银模式,2-第三方联机自助设备模式,3-第三方控件形态，4-日终批量 5-第三方联机网贷模式';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.elecdoctime is '电子凭证生成时间';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.chanelcode is '交易渠道编号';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.chaneldate is '渠道日期';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.chaneltime is '渠道时间';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.printno is '渠道打印流水号（关联各系统自己的凭证打印）';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.hostserialno is '主机流水号';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.tradecode is '交易码';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.tradename is '交易名称';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.oprbranch is '操作机构编号';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.oprteller is '操作柜员编号';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.voutype is '凭证种类';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.vouname is '凭证名称';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.scenecode is '场景码';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.content is '打印信息主联';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.content1 is '打印信息副联';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.voumodelid is '电子凭证id号';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.vousaveid is '电子凭证归档号';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.genidflag is '归档号生成方式1-平台生成 2－渠道生成';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.status is '凭证状态 1-正常 4-作废';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.userconfirmflg is '用户确认方式（0-签名、1-指纹）';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.userconfirmdata is '用户确认数据';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.fileuserinfo is '归档文件用户信息,相关字段以@@分隔';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.remark is '备注';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.remark1 is '备注1';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.elecdocno is '电子凭证流水号';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_pl_vou_vouserial_log.etl_timestamp is 'ETL处理时间戳';
