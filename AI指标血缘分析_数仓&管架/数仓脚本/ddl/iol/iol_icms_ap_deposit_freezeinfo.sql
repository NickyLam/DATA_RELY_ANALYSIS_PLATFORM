/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_deposit_freezeinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_deposit_freezeinfo
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_deposit_freezeinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_deposit_freezeinfo(
    freezeno varchar2(64) -- 记录编号
    ,deleteflag varchar2(12) -- 删除标志
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,planno varchar2(64) -- 处置内容编号
    ,signdate varchar2(64) -- 保证金冻结协议签订日期
    ,updatedate varchar2(64) -- 更新日期
    ,depositvalue number(24,6) -- 保证金金额
    ,tmsp varchar2(64) -- 时间戳
    ,inputdate varchar2(64) -- 登记日期
    ,tenderer varchar2(1000) -- 投标人
    ,updateorgid varchar2(64) -- 更新机构
    ,contractinfo varchar2(4000) -- 保证金冻结协议
    ,updateuserid varchar2(64) -- 更新人
    ,fileno varchar2(64) -- 影像平台编号
    ,bailacctno varchar2(64) -- 保证金账号
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
grant select on ${iol_schema}.icms_ap_deposit_freezeinfo to ${iml_schema};
grant select on ${iol_schema}.icms_ap_deposit_freezeinfo to ${icl_schema};
grant select on ${iol_schema}.icms_ap_deposit_freezeinfo to ${idl_schema};
grant select on ${iol_schema}.icms_ap_deposit_freezeinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_deposit_freezeinfo is '保证金冻结协议表';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.freezeno is '记录编号';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.deleteflag is '删除标志';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.planno is '处置内容编号';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.signdate is '保证金冻结协议签订日期';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.depositvalue is '保证金金额';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.tenderer is '投标人';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.contractinfo is '保证金冻结协议';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.fileno is '影像平台编号';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.bailacctno is '保证金账号';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_deposit_freezeinfo.etl_timestamp is 'ETL处理时间戳';
