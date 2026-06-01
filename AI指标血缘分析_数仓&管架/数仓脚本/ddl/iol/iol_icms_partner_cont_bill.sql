/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_partner_cont_bill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_partner_cont_bill
whenever sqlerror continue none;
drop table ${iol_schema}.icms_partner_cont_bill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_partner_cont_bill(
    contractno varchar2(48) -- 合作协议编号
    ,firstusesum number(24,6) -- 初始投资金额
    ,partnerid varchar2(64) -- 合作方客户号
    ,partnername varchar2(500) -- 合作方客户名
    ,inputuserid varchar2(64) -- 登记人
    ,coopbalance number(22,2) -- 合作额度占用额
    ,updateorgid varchar2(64) -- 更新机构
    ,startdate date -- 合作开始时间
    ,expirydate date -- 合作结束时间
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,projectname varchar2(80) -- 项目名称
    ,specailflag varchar2(1) -- 是否特殊申请
    ,inputorgid varchar2(64) -- 登记机构
    ,updatedate date -- 更新日期
    ,inputdate date -- 登记日期
    ,nominalsum number(24,6) -- 项目总额度
    ,projectno varchar2(32) -- 项目编号
    ,updateuserid varchar2(64) -- 更新人
    ,contstatus varchar2(10) -- 协议状态
    ,frozensum number(22,2) -- 冻结额度
    ,clno varchar2(48) -- 冻结额度
    ,currency varchar2(9) -- 额度币种
    ,isloop varchar2(3) -- 是否循环
    ,projectlimittype varchar2(3) -- 项目额度类型(代码：1-项目2-担保)
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
grant select on ${iol_schema}.icms_partner_cont_bill to ${iml_schema};
grant select on ${iol_schema}.icms_partner_cont_bill to ${icl_schema};
grant select on ${iol_schema}.icms_partner_cont_bill to ${idl_schema};
grant select on ${iol_schema}.icms_partner_cont_bill to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_partner_cont_bill is '合作商协议借据信息';
comment on column ${iol_schema}.icms_partner_cont_bill.contractno is '合作协议编号';
comment on column ${iol_schema}.icms_partner_cont_bill.firstusesum is '初始投资金额';
comment on column ${iol_schema}.icms_partner_cont_bill.partnerid is '合作方客户号';
comment on column ${iol_schema}.icms_partner_cont_bill.partnername is '合作方客户名';
comment on column ${iol_schema}.icms_partner_cont_bill.inputuserid is '登记人';
comment on column ${iol_schema}.icms_partner_cont_bill.coopbalance is '合作额度占用额';
comment on column ${iol_schema}.icms_partner_cont_bill.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_partner_cont_bill.startdate is '合作开始时间';
comment on column ${iol_schema}.icms_partner_cont_bill.expirydate is '合作结束时间';
comment on column ${iol_schema}.icms_partner_cont_bill.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_partner_cont_bill.projectname is '项目名称';
comment on column ${iol_schema}.icms_partner_cont_bill.specailflag is '是否特殊申请';
comment on column ${iol_schema}.icms_partner_cont_bill.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_partner_cont_bill.updatedate is '更新日期';
comment on column ${iol_schema}.icms_partner_cont_bill.inputdate is '登记日期';
comment on column ${iol_schema}.icms_partner_cont_bill.nominalsum is '项目总额度';
comment on column ${iol_schema}.icms_partner_cont_bill.projectno is '项目编号';
comment on column ${iol_schema}.icms_partner_cont_bill.updateuserid is '更新人';
comment on column ${iol_schema}.icms_partner_cont_bill.contstatus is '协议状态';
comment on column ${iol_schema}.icms_partner_cont_bill.frozensum is '冻结额度';
comment on column ${iol_schema}.icms_partner_cont_bill.clno is '冻结额度';
comment on column ${iol_schema}.icms_partner_cont_bill.currency is '额度币种';
comment on column ${iol_schema}.icms_partner_cont_bill.isloop is '是否循环';
comment on column ${iol_schema}.icms_partner_cont_bill.projectlimittype is '项目额度类型(代码：1-项目2-担保)';
comment on column ${iol_schema}.icms_partner_cont_bill.start_dt is '开始时间';
comment on column ${iol_schema}.icms_partner_cont_bill.end_dt is '结束时间';
comment on column ${iol_schema}.icms_partner_cont_bill.id_mark is '增删标志';
comment on column ${iol_schema}.icms_partner_cont_bill.etl_timestamp is 'ETL处理时间戳';
