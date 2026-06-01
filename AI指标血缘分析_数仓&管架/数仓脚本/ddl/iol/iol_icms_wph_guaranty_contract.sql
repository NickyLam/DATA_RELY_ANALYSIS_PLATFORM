/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wph_guaranty_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wph_guaranty_contract
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wph_guaranty_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_guaranty_contract(
    guarantyno varchar2(50) -- 担保合同编号
    ,guarantytype varchar2(6) -- 担保合同类型
    ,guarantystyle varchar2(12) -- 担保方式
    ,guarantystatus varchar2(12) -- 担保合同状态
    ,signdate varchar2(20) -- 协议签定日期
    ,begindate varchar2(20) -- 合同生效日
    ,enddate varchar2(20) -- 合同到期日
    ,customerid varchar2(32) -- 被担保人客户号
    ,guarantorid varchar2(60) -- 担保人编号
    ,guarantorname varchar2(200) -- 担保人名称
    ,guarantycurrency varchar2(3) -- 担保币种
    ,guarantyvalue number(24,6) -- 担保总金额
    ,guarantyinfo varchar2(1000) -- 担保物概况
    ,otherdescsribe varchar2(1000) -- 其它特别约定
    ,guarantyopinion varchar2(1000) -- 担保意见
    ,certtype varchar2(4) -- 担保人证件类型
    ,certid varchar2(60) -- 担保人证件号码
    ,loancardno varchar2(64) -- 担保人贷款卡编号
    ,guaranteeform varchar2(12) -- 保证担保形式
    ,voucheecontractno varchar2(50) -- 被担保合同号
    ,guaranteetype varchar2(12) -- 担保类型
    ,guaranteecontracttype varchar2(6) -- 唯品担保合同类型
    ,warrantortype varchar2(3) -- 保证人类别
    ,warrantorname varchar2(30) -- 保证人名称
    ,companycerttype varchar2(3) -- 证件类别
    ,companycertno varchar2(30) -- 证件号码
    ,warrantorproperty varchar2(11) -- 保证人净资产
    ,guaranteestartdate varchar2(20) -- 担保起始日期
    ,guaranteeenddate varchar2(20) -- 担保到期日期
    ,guaranteecontractstatus varchar2(3) -- 唯品担保合同状态
    ,guaranteecontractsigndate varchar2(20) -- 唯品担保合同签订日期
    ,guaranteecontracteffectdate varchar2(20) -- 唯品担保合同生效日期
    ,guaranteecontractenddate varchar2(20) -- 唯品担保合同到期日期
    ,guaranteecurrency varchar2(3) -- 唯品担保币种
    ,guaranteeamount varchar2(11) -- 唯品担保总金额
    ,guaranteerate varchar2(20) -- 担保费率
    ,inputorgid varchar2(64) -- 登记机构
    ,inputuserid varchar2(64) -- 登记人
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构
    ,updateuserid varchar2(64) -- 更新人
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_wph_guaranty_contract to ${iml_schema};
grant select on ${iol_schema}.icms_wph_guaranty_contract to ${icl_schema};
grant select on ${iol_schema}.icms_wph_guaranty_contract to ${idl_schema};
grant select on ${iol_schema}.icms_wph_guaranty_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wph_guaranty_contract is '唯品会担保合同信息表';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guarantyno is '担保合同编号';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guarantytype is '担保合同类型';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guarantystyle is '担保方式';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guarantystatus is '担保合同状态';
comment on column ${iol_schema}.icms_wph_guaranty_contract.signdate is '协议签定日期';
comment on column ${iol_schema}.icms_wph_guaranty_contract.begindate is '合同生效日';
comment on column ${iol_schema}.icms_wph_guaranty_contract.enddate is '合同到期日';
comment on column ${iol_schema}.icms_wph_guaranty_contract.customerid is '被担保人客户号';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guarantorid is '担保人编号';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guarantorname is '担保人名称';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guarantycurrency is '担保币种';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guarantyvalue is '担保总金额';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guarantyinfo is '担保物概况';
comment on column ${iol_schema}.icms_wph_guaranty_contract.otherdescsribe is '其它特别约定';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guarantyopinion is '担保意见';
comment on column ${iol_schema}.icms_wph_guaranty_contract.certtype is '担保人证件类型';
comment on column ${iol_schema}.icms_wph_guaranty_contract.certid is '担保人证件号码';
comment on column ${iol_schema}.icms_wph_guaranty_contract.loancardno is '担保人贷款卡编号';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guaranteeform is '保证担保形式';
comment on column ${iol_schema}.icms_wph_guaranty_contract.voucheecontractno is '被担保合同号';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guaranteetype is '担保类型';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guaranteecontracttype is '唯品担保合同类型';
comment on column ${iol_schema}.icms_wph_guaranty_contract.warrantortype is '保证人类别';
comment on column ${iol_schema}.icms_wph_guaranty_contract.warrantorname is '保证人名称';
comment on column ${iol_schema}.icms_wph_guaranty_contract.companycerttype is '证件类别';
comment on column ${iol_schema}.icms_wph_guaranty_contract.companycertno is '证件号码';
comment on column ${iol_schema}.icms_wph_guaranty_contract.warrantorproperty is '保证人净资产';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guaranteestartdate is '担保起始日期';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guaranteeenddate is '担保到期日期';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guaranteecontractstatus is '唯品担保合同状态';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guaranteecontractsigndate is '唯品担保合同签订日期';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guaranteecontracteffectdate is '唯品担保合同生效日期';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guaranteecontractenddate is '唯品担保合同到期日期';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guaranteecurrency is '唯品担保币种';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guaranteeamount is '唯品担保总金额';
comment on column ${iol_schema}.icms_wph_guaranty_contract.guaranteerate is '担保费率';
comment on column ${iol_schema}.icms_wph_guaranty_contract.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_wph_guaranty_contract.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wph_guaranty_contract.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wph_guaranty_contract.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wph_guaranty_contract.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wph_guaranty_contract.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wph_guaranty_contract.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wph_guaranty_contract.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wph_guaranty_contract.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wph_guaranty_contract.etl_timestamp is 'ETL处理时间戳';
