/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_jxhjbusiness_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_jxhjbusiness_contract
whenever sqlerror continue none;
drop table ${iol_schema}.icms_jxhjbusiness_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_jxhjbusiness_contract(
    serialno varchar2(32) -- 流水号
    ,purpose varchar2(200) -- 用途
    ,contextinfo varchar2(200) -- 提款说明
    ,direction varchar2(18) -- 行业投向
    ,operateorgid varchar2(32) -- 经办机构
    ,sfgjxzhy varchar2(1) -- 是否国家限制行业
    ,vouchtype varchar2(18) -- 主要担保方式
    ,updatedate varchar2(10) -- 更新日期
    ,balance number(24,6) -- 合同余额(元)
    ,ifgudingcredit varchar2(1) -- 是否固定资产授信
    ,classifyresulteleven varchar2(12) -- 风险分类
    ,manageorgid varchar2(32) -- 贷后管理机构
    ,maturity varchar2(10) -- 合同到期日
    ,relativebcserialno varchar2(32) -- 关联新业务合同流水号
    ,businesstype varchar2(18) -- 业务品种
    ,guarantytype varchar2(12) -- 担保/操作模式
    ,sfzfsx varchar2(1) -- 是否政府授信
    ,relativebaserialno varchar2(32) -- 关联新申请流水号
    ,pigeonholedate varchar2(10) -- 归档日期
    ,businesscurrency varchar2(18) -- 合同币种
    ,operatedate varchar2(10) -- 经办时间
    ,useproduct varchar2(32) -- 使用产品（贸易融资）
    ,sfgksx varchar2(1) -- 是否国开行授信
    ,inputorgid varchar2(32) -- 登记机构
    ,corpuspaymethod varchar2(18) -- 还款方式
    ,mainproduct varchar2(32) -- 经营商品（贸易融资）
    ,operateuserid varchar2(32) -- 经办人
    ,zfsxlx varchar2(8) -- 政府授信类型
    ,bailratio number(10,6) -- 保证金比例(%)
    ,bapbailratio number(10,6) -- 批复保证金比例(%)
    ,businesssum number(24,6) -- 合同金额(元)-申请阶段
    ,creditattribute varchar2(3) -- 合同类型
    ,customerid varchar2(32) -- 客户编号
    ,gksxpz varchar2(8) -- 国开授信品种
    ,importantloan varchar2(8) -- 重点贷款项目
    ,manageuserid varchar2(32) -- 贷后管理人员
    ,othercondition varchar2(4000) -- 其他条件和要求
    ,paysource varchar2(200) -- 还款说明
    ,inputuserid varchar2(32) -- 登记人
    ,gshy varchar2(8) -- 过剩行业
    ,guarantyhouse varchar2(3) -- 抵押房产套数
    ,interestrateexplain varchar2(200) -- 利率说明
    ,vouchtype1 varchar2(18) -- 担保方式（内部口径）
    ,inputdate varchar2(10) -- 登记日期
    ,relativebapserialno varchar2(32) -- 关联新批复流水号
    ,isimportantloan varchar2(8) -- 是否重点项目贷款
    ,lowrisk varchar2(18) -- 是否低风险业务
    ,financesupportmode varchar2(32) -- 贷款财政扶持方式
    ,putoutdate varchar2(10) -- 合同起始日
    ,termmonth number(22) -- 期限(月)
    ,baptermmonth number(22) -- 批复期限(月)
    ,zfsxfs varchar2(8) -- 政府授信支持方式
    ,migtflag varchar2(80) -- 
    ,bapbusinesssum number(24,6) -- 合同金额(元)-批复阶段
    ,remark varchar2(200) -- 备注
    ,artificialno varchar2(64) -- 合同文本编号
    ,drawingtype varchar2(18) -- 提款方式
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
grant select on ${iol_schema}.icms_jxhjbusiness_contract to ${iml_schema};
grant select on ${iol_schema}.icms_jxhjbusiness_contract to ${icl_schema};
grant select on ${iol_schema}.icms_jxhjbusiness_contract to ${idl_schema};
grant select on ${iol_schema}.icms_jxhjbusiness_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_jxhjbusiness_contract is '借新还旧业务合同表';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.serialno is '流水号';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.purpose is '用途';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.contextinfo is '提款说明';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.direction is '行业投向';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.sfgjxzhy is '是否国家限制行业';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.vouchtype is '主要担保方式';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.updatedate is '更新日期';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.balance is '合同余额(元)';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.ifgudingcredit is '是否固定资产授信';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.classifyresulteleven is '风险分类';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.manageorgid is '贷后管理机构';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.maturity is '合同到期日';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.relativebcserialno is '关联新业务合同流水号';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.businesstype is '业务品种';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.guarantytype is '担保/操作模式';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.sfzfsx is '是否政府授信';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.relativebaserialno is '关联新申请流水号';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.pigeonholedate is '归档日期';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.businesscurrency is '合同币种';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.operatedate is '经办时间';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.useproduct is '使用产品（贸易融资）';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.sfgksx is '是否国开行授信';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.corpuspaymethod is '还款方式';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.mainproduct is '经营商品（贸易融资）';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.operateuserid is '经办人';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.zfsxlx is '政府授信类型';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.bailratio is '保证金比例(%)';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.bapbailratio is '批复保证金比例(%)';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.businesssum is '合同金额(元)-申请阶段';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.creditattribute is '合同类型';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.customerid is '客户编号';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.gksxpz is '国开授信品种';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.importantloan is '重点贷款项目';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.manageuserid is '贷后管理人员';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.othercondition is '其他条件和要求';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.paysource is '还款说明';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.inputuserid is '登记人';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.gshy is '过剩行业';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.guarantyhouse is '抵押房产套数';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.interestrateexplain is '利率说明';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.vouchtype1 is '担保方式（内部口径）';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.inputdate is '登记日期';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.relativebapserialno is '关联新批复流水号';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.isimportantloan is '是否重点项目贷款';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.lowrisk is '是否低风险业务';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.financesupportmode is '贷款财政扶持方式';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.putoutdate is '合同起始日';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.termmonth is '期限(月)';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.baptermmonth is '批复期限(月)';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.zfsxfs is '政府授信支持方式';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.migtflag is '';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.bapbusinesssum is '合同金额(元)-批复阶段';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.remark is '备注';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.artificialno is '合同文本编号';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.drawingtype is '提款方式';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.start_dt is '开始时间';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.end_dt is '结束时间';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.id_mark is '增删标志';
comment on column ${iol_schema}.icms_jxhjbusiness_contract.etl_timestamp is 'ETL处理时间戳';
