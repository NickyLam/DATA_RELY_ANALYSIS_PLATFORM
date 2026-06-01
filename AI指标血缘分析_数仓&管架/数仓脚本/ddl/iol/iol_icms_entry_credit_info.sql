/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_entry_credit_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_entry_credit_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_entry_credit_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_entry_credit_info(
    serialno varchar2(32) -- 流水号
    ,occurdate varchar2(32) -- 发生日期
    ,productid varchar2(32) -- 业务品种
    ,issmeandretail varchar2(2) -- 是否我行小微企业并且走零售条线
    ,inputorgid varchar2(32) -- 登记机构
    ,updateorgid varchar2(32) -- 更新机构
    ,authvouchtype varchar2(32) -- 授权权限_担保方式
    ,currency varchar2(32) -- 业务币种
    ,belonguser varchar2(32) -- 贷后管理人员
    ,inputuserid varchar2(32) -- 登记人
    ,othercondition varchar2(4000) -- 额度使用条件
    ,linelatestduedate date -- 额度项下业务最迟到期日期
    ,inputdate date -- 登记日期
    ,riskattribute varchar2(32) -- 风险类型
    ,updatedate date -- 更新日期
    ,iscycle varchar2(22) -- 是否循环
    ,updateuserid varchar2(32) -- 更新人
    ,linelatestdate date -- 额度使用最迟日期
    ,otherlimittype varchar2(2) -- 他用额度类型
    ,majorbusinessloanstype varchar2(32) -- 专业贷款分类
    ,belongorg varchar2(32) -- 贷后管理机构
    ,vouchtype varchar2(32) -- 主要担保方式
    ,vouchflag varchar2(32) -- 有无其他担保方式
    ,otherlimitno varchar2(32) -- 他用额度流水号
    ,vouchtypeinner varchar2(32) -- 担保方式（内部口径）
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
grant select on ${iol_schema}.icms_entry_credit_info to ${iml_schema};
grant select on ${iol_schema}.icms_entry_credit_info to ${icl_schema};
grant select on ${iol_schema}.icms_entry_credit_info to ${idl_schema};
grant select on ${iol_schema}.icms_entry_credit_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_entry_credit_info is '录入授信信息表';
comment on column ${iol_schema}.icms_entry_credit_info.serialno is '流水号';
comment on column ${iol_schema}.icms_entry_credit_info.occurdate is '发生日期';
comment on column ${iol_schema}.icms_entry_credit_info.productid is '业务品种';
comment on column ${iol_schema}.icms_entry_credit_info.issmeandretail is '是否我行小微企业并且走零售条线';
comment on column ${iol_schema}.icms_entry_credit_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_entry_credit_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_entry_credit_info.authvouchtype is '授权权限_担保方式';
comment on column ${iol_schema}.icms_entry_credit_info.currency is '业务币种';
comment on column ${iol_schema}.icms_entry_credit_info.belonguser is '贷后管理人员';
comment on column ${iol_schema}.icms_entry_credit_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_entry_credit_info.othercondition is '额度使用条件';
comment on column ${iol_schema}.icms_entry_credit_info.linelatestduedate is '额度项下业务最迟到期日期';
comment on column ${iol_schema}.icms_entry_credit_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_entry_credit_info.riskattribute is '风险类型';
comment on column ${iol_schema}.icms_entry_credit_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_entry_credit_info.iscycle is '是否循环';
comment on column ${iol_schema}.icms_entry_credit_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_entry_credit_info.linelatestdate is '额度使用最迟日期';
comment on column ${iol_schema}.icms_entry_credit_info.otherlimittype is '他用额度类型';
comment on column ${iol_schema}.icms_entry_credit_info.majorbusinessloanstype is '专业贷款分类';
comment on column ${iol_schema}.icms_entry_credit_info.belongorg is '贷后管理机构';
comment on column ${iol_schema}.icms_entry_credit_info.vouchtype is '主要担保方式';
comment on column ${iol_schema}.icms_entry_credit_info.vouchflag is '有无其他担保方式';
comment on column ${iol_schema}.icms_entry_credit_info.otherlimitno is '他用额度流水号';
comment on column ${iol_schema}.icms_entry_credit_info.vouchtypeinner is '担保方式（内部口径）';
comment on column ${iol_schema}.icms_entry_credit_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_entry_credit_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_entry_credit_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_entry_credit_info.etl_timestamp is 'ETL处理时间戳';
