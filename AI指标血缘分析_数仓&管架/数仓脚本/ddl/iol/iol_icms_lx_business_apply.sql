/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lx_business_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lx_business_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lx_business_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_business_apply(
    serialno varchar2(64) -- 授信申请编号
    ,creditapplyid varchar2(32) -- 乐信的申请编号(资产号)
    ,partnercode varchar2(20) -- 合作方代码
    ,customerid varchar2(32) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,creditamount number(24,6) -- 授信金额(元)
    ,maritalstatus varchar2(4) -- 婚姻状况
    ,age varchar2(10) -- 年龄
    ,sex varchar2(4) -- 性别
    ,identitype varchar2(10) -- 证件类型
    ,identino varchar2(30) -- 证件号码
    ,idcardexpiredate date -- 身份证有效期止
    ,idcardvaliddate date -- 身份证有效期起
    ,idaddr varchar2(400) -- 身份证地址
    ,issuedagency varchar2(400) -- 身份证签发机关
    ,birthday date -- 出生日期
    ,nationality varchar2(60) -- 国籍
    ,nation varchar2(30) -- 民族
    ,mobileno varchar2(11) -- 客户手机号
    ,userbankcardno varchar2(30) -- 用户银行卡号
    ,fstlnkmname varchar2(200) -- 第一联系人姓名
    ,fstlnkmtel varchar2(11) -- 第一联系人手机
    ,frslnkmrela varchar2(10) -- 第一联系人关系
    ,livingaddress varchar2(400) -- 居住地址
    ,useroccupation varchar2(10) -- 客户职业
    ,userindustrycategory varchar2(10) -- 客户行业
    ,extend varchar2(4000) -- 扩展信息
    ,auditstatus varchar2(10) -- 授信审核状态
    ,approvestatus varchar2(32) -- 审批状态
    ,productid varchar2(32) -- 产品编号
    ,vouchtype varchar2(10) -- 担保方式
    ,paymenttype varchar2(20) -- 支付方式
    ,businessflag varchar2(10) -- 授信/用信标志(1-授信;2-用信)
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新日期
    ,creditno varchar2(32) -- 资方授信编号
    ,ordertype varchar2(10) -- 资产类型
    ,repaytype varchar2(10) -- 还款方式
    ,fixedbillday varchar2(8) -- 固定出账日
    ,fixedrepayday varchar2(8) -- 固定还款日
    ,loanterm number(22) -- 借款期数
    ,settlerate number(15,2) -- 结算利率
    ,loanuse varchar2(32) -- 申请贷款用途
    ,debitaccountname varchar2(64) -- 借款人收款户名
    ,debitopenaccountbank varchar2(64) -- 收款人银行卡开户行
    ,debitaccountno varchar2(64) -- 收款人银行卡卡号
    ,debitcnaps varchar2(64) -- 收款卡联行号
    ,insureid varchar2(64) -- 担保编号
    ,manualapproval varchar2(5) -- 是否人工审批标识
    ,finaldecisioncode varchar2(20) -- 最终决策结果标识
    ,finalapplyamount number(24,6) -- 最终审批额度(元)
    ,finalapplyterm number(24,0) -- 最终审批期限
    ,finalapplyvaluation number(24,6) -- 最终评估价格(元)
    ,risknote varchar2(2000) -- 风控备注
    ,riskwarm varchar2(2000) -- 风控预警
    ,educationlevel varchar2(20) -- 教育水平
    ,monthlyincome number(24,6) -- 月收入
    ,providentfundbaseamt number(24,6) -- 公积金缴纳基数
    ,securitybaseamt number(24,6) -- 社保缴纳基数
    ,providentfundcompany varchar2(200) -- 公积金缴纳单位
    ,companyaddr varchar2(500) -- 单位地址
    ,recterm number(24,0) -- 推荐期限
    ,finishtime date -- 审批完成时间
    ,userrating varchar2(10) -- 乐信用户评级
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
grant select on ${iol_schema}.icms_lx_business_apply to ${iml_schema};
grant select on ${iol_schema}.icms_lx_business_apply to ${icl_schema};
grant select on ${iol_schema}.icms_lx_business_apply to ${idl_schema};
grant select on ${iol_schema}.icms_lx_business_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lx_business_apply is '乐信授信申请信息表';
comment on column ${iol_schema}.icms_lx_business_apply.serialno is '授信申请编号';
comment on column ${iol_schema}.icms_lx_business_apply.creditapplyid is '乐信的申请编号(资产号)';
comment on column ${iol_schema}.icms_lx_business_apply.partnercode is '合作方代码';
comment on column ${iol_schema}.icms_lx_business_apply.customerid is '客户编号';
comment on column ${iol_schema}.icms_lx_business_apply.customername is '客户名称';
comment on column ${iol_schema}.icms_lx_business_apply.creditamount is '授信金额(元)';
comment on column ${iol_schema}.icms_lx_business_apply.maritalstatus is '婚姻状况';
comment on column ${iol_schema}.icms_lx_business_apply.age is '年龄';
comment on column ${iol_schema}.icms_lx_business_apply.sex is '性别';
comment on column ${iol_schema}.icms_lx_business_apply.identitype is '证件类型';
comment on column ${iol_schema}.icms_lx_business_apply.identino is '证件号码';
comment on column ${iol_schema}.icms_lx_business_apply.idcardexpiredate is '身份证有效期止';
comment on column ${iol_schema}.icms_lx_business_apply.idcardvaliddate is '身份证有效期起';
comment on column ${iol_schema}.icms_lx_business_apply.idaddr is '身份证地址';
comment on column ${iol_schema}.icms_lx_business_apply.issuedagency is '身份证签发机关';
comment on column ${iol_schema}.icms_lx_business_apply.birthday is '出生日期';
comment on column ${iol_schema}.icms_lx_business_apply.nationality is '国籍';
comment on column ${iol_schema}.icms_lx_business_apply.nation is '民族';
comment on column ${iol_schema}.icms_lx_business_apply.mobileno is '客户手机号';
comment on column ${iol_schema}.icms_lx_business_apply.userbankcardno is '用户银行卡号';
comment on column ${iol_schema}.icms_lx_business_apply.fstlnkmname is '第一联系人姓名';
comment on column ${iol_schema}.icms_lx_business_apply.fstlnkmtel is '第一联系人手机';
comment on column ${iol_schema}.icms_lx_business_apply.frslnkmrela is '第一联系人关系';
comment on column ${iol_schema}.icms_lx_business_apply.livingaddress is '居住地址';
comment on column ${iol_schema}.icms_lx_business_apply.useroccupation is '客户职业';
comment on column ${iol_schema}.icms_lx_business_apply.userindustrycategory is '客户行业';
comment on column ${iol_schema}.icms_lx_business_apply.extend is '扩展信息';
comment on column ${iol_schema}.icms_lx_business_apply.auditstatus is '授信审核状态';
comment on column ${iol_schema}.icms_lx_business_apply.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_lx_business_apply.productid is '产品编号';
comment on column ${iol_schema}.icms_lx_business_apply.vouchtype is '担保方式';
comment on column ${iol_schema}.icms_lx_business_apply.paymenttype is '支付方式';
comment on column ${iol_schema}.icms_lx_business_apply.businessflag is '授信/用信标志(1-授信;2-用信)';
comment on column ${iol_schema}.icms_lx_business_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lx_business_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lx_business_apply.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lx_business_apply.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lx_business_apply.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lx_business_apply.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lx_business_apply.creditno is '资方授信编号';
comment on column ${iol_schema}.icms_lx_business_apply.ordertype is '资产类型';
comment on column ${iol_schema}.icms_lx_business_apply.repaytype is '还款方式';
comment on column ${iol_schema}.icms_lx_business_apply.fixedbillday is '固定出账日';
comment on column ${iol_schema}.icms_lx_business_apply.fixedrepayday is '固定还款日';
comment on column ${iol_schema}.icms_lx_business_apply.loanterm is '借款期数';
comment on column ${iol_schema}.icms_lx_business_apply.settlerate is '结算利率';
comment on column ${iol_schema}.icms_lx_business_apply.loanuse is '申请贷款用途';
comment on column ${iol_schema}.icms_lx_business_apply.debitaccountname is '借款人收款户名';
comment on column ${iol_schema}.icms_lx_business_apply.debitopenaccountbank is '收款人银行卡开户行';
comment on column ${iol_schema}.icms_lx_business_apply.debitaccountno is '收款人银行卡卡号';
comment on column ${iol_schema}.icms_lx_business_apply.debitcnaps is '收款卡联行号';
comment on column ${iol_schema}.icms_lx_business_apply.insureid is '担保编号';
comment on column ${iol_schema}.icms_lx_business_apply.manualapproval is '是否人工审批标识';
comment on column ${iol_schema}.icms_lx_business_apply.finaldecisioncode is '最终决策结果标识';
comment on column ${iol_schema}.icms_lx_business_apply.finalapplyamount is '最终审批额度(元)';
comment on column ${iol_schema}.icms_lx_business_apply.finalapplyterm is '最终审批期限';
comment on column ${iol_schema}.icms_lx_business_apply.finalapplyvaluation is '最终评估价格(元)';
comment on column ${iol_schema}.icms_lx_business_apply.risknote is '风控备注';
comment on column ${iol_schema}.icms_lx_business_apply.riskwarm is '风控预警';
comment on column ${iol_schema}.icms_lx_business_apply.educationlevel is '教育水平';
comment on column ${iol_schema}.icms_lx_business_apply.monthlyincome is '月收入';
comment on column ${iol_schema}.icms_lx_business_apply.providentfundbaseamt is '公积金缴纳基数';
comment on column ${iol_schema}.icms_lx_business_apply.securitybaseamt is '社保缴纳基数';
comment on column ${iol_schema}.icms_lx_business_apply.providentfundcompany is '公积金缴纳单位';
comment on column ${iol_schema}.icms_lx_business_apply.companyaddr is '单位地址';
comment on column ${iol_schema}.icms_lx_business_apply.recterm is '推荐期限';
comment on column ${iol_schema}.icms_lx_business_apply.finishtime is '审批完成时间';
comment on column ${iol_schema}.icms_lx_business_apply.userrating is '乐信用户评级';
comment on column ${iol_schema}.icms_lx_business_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lx_business_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lx_business_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lx_business_apply.etl_timestamp is 'ETL处理时间戳';
