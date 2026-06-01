/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zxz_package_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zxz_package_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zxz_package_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zxz_package_info(
    packageno varchar2(32) -- 编号
    ,putoutaccount varchar2(64) -- 资金划出账户
    ,bpfilename varchar2(200) -- 人行文件名称
    ,bplimit number(24,6) -- （人行额度（元）
    ,pledgesum number(24,6) -- 抵质押物金额（估值)(小计)
    ,inputaccount varchar2(64) -- 资金划入账户
    ,belongpbunitleadername varchar2(64) -- 所属地人民银行单位负责人姓名
    ,belongpbname varchar2(64) -- 所属地人民银行名称
    ,relpackagename varchar2(200) -- 关联批次包名称
    ,usedesc varchar2(4000) -- 使用要求
    ,applyamount number(16,2) -- 再贷款金额
    ,zxzrealityiry number(16,9) -- 使用利率
    ,relpackageno varchar2(32) -- 关联批次包编号关联一、二级批次包
    ,zxzcontno varchar2(32) -- 再贷款合同编号
    ,zxzloanstartdate date -- 再贷款发放日期
    ,inputuserid varchar2(64) -- 登记人
    ,inputdate date -- 登记日期
    ,migtflag varchar2(80) -- 
    ,failreason varchar2(1000) -- 备注
    ,creditortype varchar2(20) -- 人民银行债权类型
    ,bpfileusedate date -- 人行文件发文日期
    ,inputorgid varchar2(64) -- 登记机构
    ,loanstype varchar2(64) -- 再贷款类型
    ,unitphone varchar2(64) -- 单位地址联系电话
    ,unitaddress varchar2(200) -- 单位地址
    ,packagename varchar2(200) -- 批次包的名称
    ,loanbalance number(16,2) -- 剩余额度
    ,zxzloanmode varchar2(20) -- 再贷款发放模式
    ,belongpborgid varchar2(64) -- 所属地人民银行金融机构编码
    ,bearingtype varchar2(64) -- 计息方式
    ,creditorbalance number(24,6) -- 债权余额
    ,packageflag varchar2(10) -- 批次包标识1：一级包2：二级包
    ,packagestatus varchar2(32) -- 批次包状态
    ,zxzenddate date -- 再贷款到期日期
    ,bpfileno varchar2(500) -- 人行文件文号
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
grant select on ${iol_schema}.icms_zxz_package_info to ${iml_schema};
grant select on ${iol_schema}.icms_zxz_package_info to ${icl_schema};
grant select on ${iol_schema}.icms_zxz_package_info to ${idl_schema};
grant select on ${iol_schema}.icms_zxz_package_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zxz_package_info is '支小再贷款批次包';
comment on column ${iol_schema}.icms_zxz_package_info.packageno is '编号';
comment on column ${iol_schema}.icms_zxz_package_info.putoutaccount is '资金划出账户';
comment on column ${iol_schema}.icms_zxz_package_info.bpfilename is '人行文件名称';
comment on column ${iol_schema}.icms_zxz_package_info.bplimit is '（人行额度（元）';
comment on column ${iol_schema}.icms_zxz_package_info.pledgesum is '抵质押物金额（估值)(小计)';
comment on column ${iol_schema}.icms_zxz_package_info.inputaccount is '资金划入账户';
comment on column ${iol_schema}.icms_zxz_package_info.belongpbunitleadername is '所属地人民银行单位负责人姓名';
comment on column ${iol_schema}.icms_zxz_package_info.belongpbname is '所属地人民银行名称';
comment on column ${iol_schema}.icms_zxz_package_info.relpackagename is '关联批次包名称';
comment on column ${iol_schema}.icms_zxz_package_info.usedesc is '使用要求';
comment on column ${iol_schema}.icms_zxz_package_info.applyamount is '再贷款金额';
comment on column ${iol_schema}.icms_zxz_package_info.zxzrealityiry is '使用利率';
comment on column ${iol_schema}.icms_zxz_package_info.relpackageno is '关联批次包编号关联一、二级批次包';
comment on column ${iol_schema}.icms_zxz_package_info.zxzcontno is '再贷款合同编号';
comment on column ${iol_schema}.icms_zxz_package_info.zxzloanstartdate is '再贷款发放日期';
comment on column ${iol_schema}.icms_zxz_package_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_zxz_package_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_zxz_package_info.migtflag is '';
comment on column ${iol_schema}.icms_zxz_package_info.failreason is '备注';
comment on column ${iol_schema}.icms_zxz_package_info.creditortype is '人民银行债权类型';
comment on column ${iol_schema}.icms_zxz_package_info.bpfileusedate is '人行文件发文日期';
comment on column ${iol_schema}.icms_zxz_package_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_zxz_package_info.loanstype is '再贷款类型';
comment on column ${iol_schema}.icms_zxz_package_info.unitphone is '单位地址联系电话';
comment on column ${iol_schema}.icms_zxz_package_info.unitaddress is '单位地址';
comment on column ${iol_schema}.icms_zxz_package_info.packagename is '批次包的名称';
comment on column ${iol_schema}.icms_zxz_package_info.loanbalance is '剩余额度';
comment on column ${iol_schema}.icms_zxz_package_info.zxzloanmode is '再贷款发放模式';
comment on column ${iol_schema}.icms_zxz_package_info.belongpborgid is '所属地人民银行金融机构编码';
comment on column ${iol_schema}.icms_zxz_package_info.bearingtype is '计息方式';
comment on column ${iol_schema}.icms_zxz_package_info.creditorbalance is '债权余额';
comment on column ${iol_schema}.icms_zxz_package_info.packageflag is '批次包标识1：一级包2：二级包';
comment on column ${iol_schema}.icms_zxz_package_info.packagestatus is '批次包状态';
comment on column ${iol_schema}.icms_zxz_package_info.zxzenddate is '再贷款到期日期';
comment on column ${iol_schema}.icms_zxz_package_info.bpfileno is '人行文件文号';
comment on column ${iol_schema}.icms_zxz_package_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zxz_package_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zxz_package_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zxz_package_info.etl_timestamp is 'ETL处理时间戳';
