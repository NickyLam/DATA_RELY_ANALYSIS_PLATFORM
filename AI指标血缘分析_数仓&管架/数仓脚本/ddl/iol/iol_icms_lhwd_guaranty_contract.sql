/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhwd_guaranty_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhwd_guaranty_contract
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhwd_guaranty_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_guaranty_contract(
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
    ,checkguarantydate varchar2(20) -- 核保日期
    ,checkguarantymana varchar2(400) -- 核保人;一）
    ,checkguarantymanb varchar2(400) -- 核保人;二）
    ,certtype varchar2(4) -- 担保人证件类型
    ,certid varchar2(60) -- 担保人证件号码
    ,loancardno varchar2(64) -- 担保人贷款卡编号
    ,guaranteeform varchar2(12) -- 保证担保形式
    ,ypguarantorid varchar2(64) -- 押品系统保证人id
    ,guarantyfax varchar2(20) -- 保证人传真
    ,guarantyphone varchar2(20) -- 保证人电话
    ,guarantyaddress varchar2(80) -- 保证人地址
    ,creditchannel varchar2(32) -- 授信渠道
    ,guarterm number(30,0) -- 担保期限(月)
    ,usesum number(20,2) -- 已担保金额
    ,guarbalance number(20,2) -- 可用余额
    ,guartorcate varchar2(2) -- 担保人类别
    ,customerriskactualrate number(24,6) -- 客户风险实际抵质押率
    ,isguarantyplatformloan varchar2(2) -- 是否政府性融资担保公司保证
    ,isbackguaranty varchar2(2) -- 是否反担保
    ,maximumguarability number(24,6) -- 保证人保证能力上限
    ,approvalandpledgerate number(15,8) -- 审批抵质押率
    ,clno varchar2(100) -- 关联项目/他用额度编号
    ,artificialno varchar2(300) -- 中文合同编号
    ,remark varchar2(1000) -- 备注
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
grant select on ${iol_schema}.icms_lhwd_guaranty_contract to ${iml_schema};
grant select on ${iol_schema}.icms_lhwd_guaranty_contract to ${icl_schema};
grant select on ${iol_schema}.icms_lhwd_guaranty_contract to ${idl_schema};
grant select on ${iol_schema}.icms_lhwd_guaranty_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhwd_guaranty_contract is '联合网贷担保合同表';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guarantyno is '担保合同编号';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guarantytype is '担保合同类型';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guarantystyle is '担保方式';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guarantystatus is '担保合同状态';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.signdate is '协议签定日期';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.begindate is '合同生效日';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.enddate is '合同到期日';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.customerid is '被担保人客户号';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guarantorid is '担保人编号';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guarantorname is '担保人名称';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guarantycurrency is '担保币种';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guarantyvalue is '担保总金额';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guarantyinfo is '担保物概况';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.otherdescsribe is '其它特别约定';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guarantyopinion is '担保意见';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.checkguarantydate is '核保日期';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.checkguarantymana is '核保人;一）';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.checkguarantymanb is '核保人;二）';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.certtype is '担保人证件类型';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.certid is '担保人证件号码';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.loancardno is '担保人贷款卡编号';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guaranteeform is '保证担保形式';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.ypguarantorid is '押品系统保证人id';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guarantyfax is '保证人传真';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guarantyphone is '保证人电话';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guarantyaddress is '保证人地址';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.creditchannel is '授信渠道';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guarterm is '担保期限(月)';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.usesum is '已担保金额';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guarbalance is '可用余额';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.guartorcate is '担保人类别';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.customerriskactualrate is '客户风险实际抵质押率';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.isguarantyplatformloan is '是否政府性融资担保公司保证';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.isbackguaranty is '是否反担保';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.maximumguarability is '保证人保证能力上限';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.approvalandpledgerate is '审批抵质押率';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.clno is '关联项目/他用额度编号';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.artificialno is '中文合同编号';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.remark is '备注';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lhwd_guaranty_contract.etl_timestamp is 'ETL处理时间戳';
