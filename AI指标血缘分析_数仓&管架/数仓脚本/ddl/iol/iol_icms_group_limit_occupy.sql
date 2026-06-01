/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_group_limit_occupy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_group_limit_occupy
whenever sqlerror continue none;
drop table ${iol_schema}.icms_group_limit_occupy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_group_limit_occupy(
    fromsystem varchar2(6) -- 来源系统
    ,objectno varchar2(40) -- 业务流水号
    ,balance number(24,6) -- 余额
    ,inputtime varchar2(25) -- 登记时间(格式：YYYY/MM/DDhh:mm:ss)
    ,businesscurrency varchar2(10) -- 币种
    ,groupcustomerid varchar2(40) -- 关联信贷集团客户号
    ,mfcustomerid varchar2(40) -- 申请人核心客户号
    ,relacustomerid varchar2(40) -- 关联公司客户号(注：个人客户关联的公司客户)
    ,updatetime varchar2(25) -- 更新时间(格式：YYYY/MM/DDhh:mm:ss)
    ,balancechangetime varchar2(25) -- 余额变化时间(格式：YYYY/MM/DDhh:mm:ss)
    ,bailsum number(24,6) -- 保证金(折人民币元)
    ,putoutdate varchar2(10) -- 起始日期(格式：YYYY/MM/DD)
    ,relacustomername varchar2(200) -- 关联公司客户号名称(注：个人客户作为法代、实控人、股东关联的公司客户)
    ,businesssum number(24,6) -- 申请金额
    ,contractno varchar2(32) -- 贷款合同号
    ,customerid varchar2(40) -- 申请人信贷客户号
    ,effectflag varchar2(10) -- 生效状态
    ,customername varchar2(200) -- 申请人信贷客户名称
    ,certid varchar2(40) -- 申请人证件号码
    ,totalputoutsum number(24,6) -- 累计发放金额
    ,totalsum number(24,6) -- 敞口金额(折人民币元)
    ,lowriskassuresum number(24,6) -- 低风险担保金额(折人民币元)
    ,groupcustomername varchar2(200) -- 关联信贷集团客户名称
    ,grouplimitid varchar2(32) -- 关联集团限额流水
    ,cycleflag varchar2(10) -- 是否循环
    ,maturity varchar2(10) -- 到期日期(格式：YYYY/MM/DD)
    ,certtype varchar2(20) -- 申请人证件类型
    ,statuschangetime varchar2(25) -- 状态变化时间(格式：YYYY/MM/DDhh:mm:ss)
    ,businesstype varchar2(32) -- 业务品种代码
    ,businesstypename varchar2(80) -- 业务品种名称
    ,relacustomertype varchar2(6) -- 关联公司客户类型(注：个人客户作为法代、实控人、股东关联的公司客户)
    ,relatype varchar2(6) -- 关联类型(参考：集团成员、法人代表、实控人、股东)
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,applycustomername varchar2(200) -- 客户名称(零售推送)
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
grant select on ${iol_schema}.icms_group_limit_occupy to ${iml_schema};
grant select on ${iol_schema}.icms_group_limit_occupy to ${icl_schema};
grant select on ${iol_schema}.icms_group_limit_occupy to ${idl_schema};
grant select on ${iol_schema}.icms_group_limit_occupy to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_group_limit_occupy is '集团限额占用关系表';
comment on column ${iol_schema}.icms_group_limit_occupy.fromsystem is '来源系统';
comment on column ${iol_schema}.icms_group_limit_occupy.objectno is '业务流水号';
comment on column ${iol_schema}.icms_group_limit_occupy.balance is '余额';
comment on column ${iol_schema}.icms_group_limit_occupy.inputtime is '登记时间(格式：YYYY/MM/DDhh:mm:ss)';
comment on column ${iol_schema}.icms_group_limit_occupy.businesscurrency is '币种';
comment on column ${iol_schema}.icms_group_limit_occupy.groupcustomerid is '关联信贷集团客户号';
comment on column ${iol_schema}.icms_group_limit_occupy.mfcustomerid is '申请人核心客户号';
comment on column ${iol_schema}.icms_group_limit_occupy.relacustomerid is '关联公司客户号(注：个人客户关联的公司客户)';
comment on column ${iol_schema}.icms_group_limit_occupy.updatetime is '更新时间(格式：YYYY/MM/DDhh:mm:ss)';
comment on column ${iol_schema}.icms_group_limit_occupy.balancechangetime is '余额变化时间(格式：YYYY/MM/DDhh:mm:ss)';
comment on column ${iol_schema}.icms_group_limit_occupy.bailsum is '保证金(折人民币元)';
comment on column ${iol_schema}.icms_group_limit_occupy.putoutdate is '起始日期(格式：YYYY/MM/DD)';
comment on column ${iol_schema}.icms_group_limit_occupy.relacustomername is '关联公司客户号名称(注：个人客户作为法代、实控人、股东关联的公司客户)';
comment on column ${iol_schema}.icms_group_limit_occupy.businesssum is '申请金额';
comment on column ${iol_schema}.icms_group_limit_occupy.contractno is '贷款合同号';
comment on column ${iol_schema}.icms_group_limit_occupy.customerid is '申请人信贷客户号';
comment on column ${iol_schema}.icms_group_limit_occupy.effectflag is '生效状态';
comment on column ${iol_schema}.icms_group_limit_occupy.customername is '申请人信贷客户名称';
comment on column ${iol_schema}.icms_group_limit_occupy.certid is '申请人证件号码';
comment on column ${iol_schema}.icms_group_limit_occupy.totalputoutsum is '累计发放金额';
comment on column ${iol_schema}.icms_group_limit_occupy.totalsum is '敞口金额(折人民币元)';
comment on column ${iol_schema}.icms_group_limit_occupy.lowriskassuresum is '低风险担保金额(折人民币元)';
comment on column ${iol_schema}.icms_group_limit_occupy.groupcustomername is '关联信贷集团客户名称';
comment on column ${iol_schema}.icms_group_limit_occupy.grouplimitid is '关联集团限额流水';
comment on column ${iol_schema}.icms_group_limit_occupy.cycleflag is '是否循环';
comment on column ${iol_schema}.icms_group_limit_occupy.maturity is '到期日期(格式：YYYY/MM/DD)';
comment on column ${iol_schema}.icms_group_limit_occupy.certtype is '申请人证件类型';
comment on column ${iol_schema}.icms_group_limit_occupy.statuschangetime is '状态变化时间(格式：YYYY/MM/DDhh:mm:ss)';
comment on column ${iol_schema}.icms_group_limit_occupy.businesstype is '业务品种代码';
comment on column ${iol_schema}.icms_group_limit_occupy.businesstypename is '业务品种名称';
comment on column ${iol_schema}.icms_group_limit_occupy.relacustomertype is '关联公司客户类型(注：个人客户作为法代、实控人、股东关联的公司客户)';
comment on column ${iol_schema}.icms_group_limit_occupy.relatype is '关联类型(参考：集团成员、法人代表、实控人、股东)';
comment on column ${iol_schema}.icms_group_limit_occupy.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_group_limit_occupy.applycustomername is '客户名称(零售推送)';
comment on column ${iol_schema}.icms_group_limit_occupy.start_dt is '开始时间';
comment on column ${iol_schema}.icms_group_limit_occupy.end_dt is '结束时间';
comment on column ${iol_schema}.icms_group_limit_occupy.id_mark is '增删标志';
comment on column ${iol_schema}.icms_group_limit_occupy.etl_timestamp is 'ETL处理时间戳';
