/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lx_business_apply
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.icms_lx_business_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_lx_business_apply
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lx_business_apply_op purge;
drop table ${iol_schema}.icms_lx_business_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_business_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lx_business_apply where 0=1;

create table ${iol_schema}.icms_lx_business_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lx_business_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lx_business_apply_cl(
            serialno -- 授信申请编号
            ,creditapplyid -- 乐信的申请编号(资产号)
            ,partnercode -- 合作方代码
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,creditamount -- 授信金额(元)
            ,maritalstatus -- 婚姻状况
            ,age -- 年龄
            ,sex -- 性别
            ,identitype -- 证件类型
            ,identino -- 证件号码
            ,idcardexpiredate -- 身份证有效期止
            ,idcardvaliddate -- 身份证有效期起
            ,idaddr -- 身份证地址
            ,issuedagency -- 身份证签发机关
            ,birthday -- 出生日期
            ,nationality -- 国籍
            ,nation -- 民族
            ,mobileno -- 客户手机号
            ,userbankcardno -- 用户银行卡号
            ,fstlnkmname -- 第一联系人姓名
            ,fstlnkmtel -- 第一联系人手机
            ,frslnkmrela -- 第一联系人关系
            ,livingaddress -- 居住地址
            ,useroccupation -- 客户职业
            ,userindustrycategory -- 客户行业
            ,extend -- 扩展信息
            ,auditstatus -- 授信审核状态
            ,approvestatus -- 审批状态
            ,productid -- 产品编号
            ,vouchtype -- 担保方式
            ,paymenttype -- 支付方式
            ,businessflag -- 授信/用信标志(1-授信;2-用信)
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,creditno -- 资方授信编号
            ,ordertype -- 资产类型
            ,repaytype -- 还款方式
            ,fixedbillday -- 固定出账日
            ,fixedrepayday -- 固定还款日
            ,loanterm -- 借款期数
            ,settlerate -- 结算利率
            ,loanuse -- 申请贷款用途
            ,debitaccountname -- 借款人收款户名
            ,debitopenaccountbank -- 收款人银行卡开户行
            ,debitaccountno -- 收款人银行卡卡号
            ,debitcnaps -- 收款卡联行号
            ,insureid -- 担保编号
            ,manualapproval -- 是否人工审批标识
            ,finaldecisioncode -- 最终决策结果标识
            ,finalapplyamount -- 最终审批额度(元)
            ,finalapplyterm -- 最终审批期限
            ,finalapplyvaluation -- 最终评估价格(元)
            ,risknote -- 风控备注
            ,riskwarm -- 风控预警
            ,educationlevel -- 教育水平
            ,monthlyincome -- 月收入
            ,providentfundbaseamt -- 公积金缴纳基数
            ,securitybaseamt -- 社保缴纳基数
            ,providentfundcompany -- 公积金缴纳单位
            ,companyaddr -- 单位地址
            ,recterm -- 推荐期限
            ,finishtime -- 审批完成时间
            ,userrating -- 乐信用户评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lx_business_apply_op(
            serialno -- 授信申请编号
            ,creditapplyid -- 乐信的申请编号(资产号)
            ,partnercode -- 合作方代码
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,creditamount -- 授信金额(元)
            ,maritalstatus -- 婚姻状况
            ,age -- 年龄
            ,sex -- 性别
            ,identitype -- 证件类型
            ,identino -- 证件号码
            ,idcardexpiredate -- 身份证有效期止
            ,idcardvaliddate -- 身份证有效期起
            ,idaddr -- 身份证地址
            ,issuedagency -- 身份证签发机关
            ,birthday -- 出生日期
            ,nationality -- 国籍
            ,nation -- 民族
            ,mobileno -- 客户手机号
            ,userbankcardno -- 用户银行卡号
            ,fstlnkmname -- 第一联系人姓名
            ,fstlnkmtel -- 第一联系人手机
            ,frslnkmrela -- 第一联系人关系
            ,livingaddress -- 居住地址
            ,useroccupation -- 客户职业
            ,userindustrycategory -- 客户行业
            ,extend -- 扩展信息
            ,auditstatus -- 授信审核状态
            ,approvestatus -- 审批状态
            ,productid -- 产品编号
            ,vouchtype -- 担保方式
            ,paymenttype -- 支付方式
            ,businessflag -- 授信/用信标志(1-授信;2-用信)
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,creditno -- 资方授信编号
            ,ordertype -- 资产类型
            ,repaytype -- 还款方式
            ,fixedbillday -- 固定出账日
            ,fixedrepayday -- 固定还款日
            ,loanterm -- 借款期数
            ,settlerate -- 结算利率
            ,loanuse -- 申请贷款用途
            ,debitaccountname -- 借款人收款户名
            ,debitopenaccountbank -- 收款人银行卡开户行
            ,debitaccountno -- 收款人银行卡卡号
            ,debitcnaps -- 收款卡联行号
            ,insureid -- 担保编号
            ,manualapproval -- 是否人工审批标识
            ,finaldecisioncode -- 最终决策结果标识
            ,finalapplyamount -- 最终审批额度(元)
            ,finalapplyterm -- 最终审批期限
            ,finalapplyvaluation -- 最终评估价格(元)
            ,risknote -- 风控备注
            ,riskwarm -- 风控预警
            ,educationlevel -- 教育水平
            ,monthlyincome -- 月收入
            ,providentfundbaseamt -- 公积金缴纳基数
            ,securitybaseamt -- 社保缴纳基数
            ,providentfundcompany -- 公积金缴纳单位
            ,companyaddr -- 单位地址
            ,recterm -- 推荐期限
            ,finishtime -- 审批完成时间
            ,userrating -- 乐信用户评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 授信申请编号
    ,nvl(n.creditapplyid, o.creditapplyid) as creditapplyid -- 乐信的申请编号(资产号)
    ,nvl(n.partnercode, o.partnercode) as partnercode -- 合作方代码
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.creditamount, o.creditamount) as creditamount -- 授信金额(元)
    ,nvl(n.maritalstatus, o.maritalstatus) as maritalstatus -- 婚姻状况
    ,nvl(n.age, o.age) as age -- 年龄
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.identitype, o.identitype) as identitype -- 证件类型
    ,nvl(n.identino, o.identino) as identino -- 证件号码
    ,nvl(n.idcardexpiredate, o.idcardexpiredate) as idcardexpiredate -- 身份证有效期止
    ,nvl(n.idcardvaliddate, o.idcardvaliddate) as idcardvaliddate -- 身份证有效期起
    ,nvl(n.idaddr, o.idaddr) as idaddr -- 身份证地址
    ,nvl(n.issuedagency, o.issuedagency) as issuedagency -- 身份证签发机关
    ,nvl(n.birthday, o.birthday) as birthday -- 出生日期
    ,nvl(n.nationality, o.nationality) as nationality -- 国籍
    ,nvl(n.nation, o.nation) as nation -- 民族
    ,nvl(n.mobileno, o.mobileno) as mobileno -- 客户手机号
    ,nvl(n.userbankcardno, o.userbankcardno) as userbankcardno -- 用户银行卡号
    ,nvl(n.fstlnkmname, o.fstlnkmname) as fstlnkmname -- 第一联系人姓名
    ,nvl(n.fstlnkmtel, o.fstlnkmtel) as fstlnkmtel -- 第一联系人手机
    ,nvl(n.frslnkmrela, o.frslnkmrela) as frslnkmrela -- 第一联系人关系
    ,nvl(n.livingaddress, o.livingaddress) as livingaddress -- 居住地址
    ,nvl(n.useroccupation, o.useroccupation) as useroccupation -- 客户职业
    ,nvl(n.userindustrycategory, o.userindustrycategory) as userindustrycategory -- 客户行业
    ,nvl(n.extend, o.extend) as extend -- 扩展信息
    ,nvl(n.auditstatus, o.auditstatus) as auditstatus -- 授信审核状态
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 担保方式
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 支付方式
    ,nvl(n.businessflag, o.businessflag) as businessflag -- 授信/用信标志(1-授信;2-用信)
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.creditno, o.creditno) as creditno -- 资方授信编号
    ,nvl(n.ordertype, o.ordertype) as ordertype -- 资产类型
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.fixedbillday, o.fixedbillday) as fixedbillday -- 固定出账日
    ,nvl(n.fixedrepayday, o.fixedrepayday) as fixedrepayday -- 固定还款日
    ,nvl(n.loanterm, o.loanterm) as loanterm -- 借款期数
    ,nvl(n.settlerate, o.settlerate) as settlerate -- 结算利率
    ,nvl(n.loanuse, o.loanuse) as loanuse -- 申请贷款用途
    ,nvl(n.debitaccountname, o.debitaccountname) as debitaccountname -- 借款人收款户名
    ,nvl(n.debitopenaccountbank, o.debitopenaccountbank) as debitopenaccountbank -- 收款人银行卡开户行
    ,nvl(n.debitaccountno, o.debitaccountno) as debitaccountno -- 收款人银行卡卡号
    ,nvl(n.debitcnaps, o.debitcnaps) as debitcnaps -- 收款卡联行号
    ,nvl(n.insureid, o.insureid) as insureid -- 担保编号
    ,nvl(n.manualapproval, o.manualapproval) as manualapproval -- 是否人工审批标识
    ,nvl(n.finaldecisioncode, o.finaldecisioncode) as finaldecisioncode -- 最终决策结果标识
    ,nvl(n.finalapplyamount, o.finalapplyamount) as finalapplyamount -- 最终审批额度(元)
    ,nvl(n.finalapplyterm, o.finalapplyterm) as finalapplyterm -- 最终审批期限
    ,nvl(n.finalapplyvaluation, o.finalapplyvaluation) as finalapplyvaluation -- 最终评估价格(元)
    ,nvl(n.risknote, o.risknote) as risknote -- 风控备注
    ,nvl(n.riskwarm, o.riskwarm) as riskwarm -- 风控预警
    ,nvl(n.educationlevel, o.educationlevel) as educationlevel -- 教育水平
    ,nvl(n.monthlyincome, o.monthlyincome) as monthlyincome -- 月收入
    ,nvl(n.providentfundbaseamt, o.providentfundbaseamt) as providentfundbaseamt -- 公积金缴纳基数
    ,nvl(n.securitybaseamt, o.securitybaseamt) as securitybaseamt -- 社保缴纳基数
    ,nvl(n.providentfundcompany, o.providentfundcompany) as providentfundcompany -- 公积金缴纳单位
    ,nvl(n.companyaddr, o.companyaddr) as companyaddr -- 单位地址
    ,nvl(n.recterm, o.recterm) as recterm -- 推荐期限
    ,nvl(n.finishtime, o.finishtime) as finishtime -- 审批完成时间
    ,nvl(n.userrating, o.userrating) as userrating -- 乐信用户评级
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_lx_business_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_lx_business_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.creditapplyid <> n.creditapplyid
        or o.partnercode <> n.partnercode
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.creditamount <> n.creditamount
        or o.maritalstatus <> n.maritalstatus
        or o.age <> n.age
        or o.sex <> n.sex
        or o.identitype <> n.identitype
        or o.identino <> n.identino
        or o.idcardexpiredate <> n.idcardexpiredate
        or o.idcardvaliddate <> n.idcardvaliddate
        or o.idaddr <> n.idaddr
        or o.issuedagency <> n.issuedagency
        or o.birthday <> n.birthday
        or o.nationality <> n.nationality
        or o.nation <> n.nation
        or o.mobileno <> n.mobileno
        or o.userbankcardno <> n.userbankcardno
        or o.fstlnkmname <> n.fstlnkmname
        or o.fstlnkmtel <> n.fstlnkmtel
        or o.frslnkmrela <> n.frslnkmrela
        or o.livingaddress <> n.livingaddress
        or o.useroccupation <> n.useroccupation
        or o.userindustrycategory <> n.userindustrycategory
        or o.extend <> n.extend
        or o.auditstatus <> n.auditstatus
        or o.approvestatus <> n.approvestatus
        or o.productid <> n.productid
        or o.vouchtype <> n.vouchtype
        or o.paymenttype <> n.paymenttype
        or o.businessflag <> n.businessflag
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.creditno <> n.creditno
        or o.ordertype <> n.ordertype
        or o.repaytype <> n.repaytype
        or o.fixedbillday <> n.fixedbillday
        or o.fixedrepayday <> n.fixedrepayday
        or o.loanterm <> n.loanterm
        or o.settlerate <> n.settlerate
        or o.loanuse <> n.loanuse
        or o.debitaccountname <> n.debitaccountname
        or o.debitopenaccountbank <> n.debitopenaccountbank
        or o.debitaccountno <> n.debitaccountno
        or o.debitcnaps <> n.debitcnaps
        or o.insureid <> n.insureid
        or o.manualapproval <> n.manualapproval
        or o.finaldecisioncode <> n.finaldecisioncode
        or o.finalapplyamount <> n.finalapplyamount
        or o.finalapplyterm <> n.finalapplyterm
        or o.finalapplyvaluation <> n.finalapplyvaluation
        or o.risknote <> n.risknote
        or o.riskwarm <> n.riskwarm
        or o.educationlevel <> n.educationlevel
        or o.monthlyincome <> n.monthlyincome
        or o.providentfundbaseamt <> n.providentfundbaseamt
        or o.securitybaseamt <> n.securitybaseamt
        or o.providentfundcompany <> n.providentfundcompany
        or o.companyaddr <> n.companyaddr
        or o.recterm <> n.recterm
        or o.finishtime <> n.finishtime
        or o.userrating <> n.userrating
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lx_business_apply_cl(
            serialno -- 授信申请编号
            ,creditapplyid -- 乐信的申请编号(资产号)
            ,partnercode -- 合作方代码
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,creditamount -- 授信金额(元)
            ,maritalstatus -- 婚姻状况
            ,age -- 年龄
            ,sex -- 性别
            ,identitype -- 证件类型
            ,identino -- 证件号码
            ,idcardexpiredate -- 身份证有效期止
            ,idcardvaliddate -- 身份证有效期起
            ,idaddr -- 身份证地址
            ,issuedagency -- 身份证签发机关
            ,birthday -- 出生日期
            ,nationality -- 国籍
            ,nation -- 民族
            ,mobileno -- 客户手机号
            ,userbankcardno -- 用户银行卡号
            ,fstlnkmname -- 第一联系人姓名
            ,fstlnkmtel -- 第一联系人手机
            ,frslnkmrela -- 第一联系人关系
            ,livingaddress -- 居住地址
            ,useroccupation -- 客户职业
            ,userindustrycategory -- 客户行业
            ,extend -- 扩展信息
            ,auditstatus -- 授信审核状态
            ,approvestatus -- 审批状态
            ,productid -- 产品编号
            ,vouchtype -- 担保方式
            ,paymenttype -- 支付方式
            ,businessflag -- 授信/用信标志(1-授信;2-用信)
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,creditno -- 资方授信编号
            ,ordertype -- 资产类型
            ,repaytype -- 还款方式
            ,fixedbillday -- 固定出账日
            ,fixedrepayday -- 固定还款日
            ,loanterm -- 借款期数
            ,settlerate -- 结算利率
            ,loanuse -- 申请贷款用途
            ,debitaccountname -- 借款人收款户名
            ,debitopenaccountbank -- 收款人银行卡开户行
            ,debitaccountno -- 收款人银行卡卡号
            ,debitcnaps -- 收款卡联行号
            ,insureid -- 担保编号
            ,manualapproval -- 是否人工审批标识
            ,finaldecisioncode -- 最终决策结果标识
            ,finalapplyamount -- 最终审批额度(元)
            ,finalapplyterm -- 最终审批期限
            ,finalapplyvaluation -- 最终评估价格(元)
            ,risknote -- 风控备注
            ,riskwarm -- 风控预警
            ,educationlevel -- 教育水平
            ,monthlyincome -- 月收入
            ,providentfundbaseamt -- 公积金缴纳基数
            ,securitybaseamt -- 社保缴纳基数
            ,providentfundcompany -- 公积金缴纳单位
            ,companyaddr -- 单位地址
            ,recterm -- 推荐期限
            ,finishtime -- 审批完成时间
            ,userrating -- 乐信用户评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lx_business_apply_op(
            serialno -- 授信申请编号
            ,creditapplyid -- 乐信的申请编号(资产号)
            ,partnercode -- 合作方代码
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,creditamount -- 授信金额(元)
            ,maritalstatus -- 婚姻状况
            ,age -- 年龄
            ,sex -- 性别
            ,identitype -- 证件类型
            ,identino -- 证件号码
            ,idcardexpiredate -- 身份证有效期止
            ,idcardvaliddate -- 身份证有效期起
            ,idaddr -- 身份证地址
            ,issuedagency -- 身份证签发机关
            ,birthday -- 出生日期
            ,nationality -- 国籍
            ,nation -- 民族
            ,mobileno -- 客户手机号
            ,userbankcardno -- 用户银行卡号
            ,fstlnkmname -- 第一联系人姓名
            ,fstlnkmtel -- 第一联系人手机
            ,frslnkmrela -- 第一联系人关系
            ,livingaddress -- 居住地址
            ,useroccupation -- 客户职业
            ,userindustrycategory -- 客户行业
            ,extend -- 扩展信息
            ,auditstatus -- 授信审核状态
            ,approvestatus -- 审批状态
            ,productid -- 产品编号
            ,vouchtype -- 担保方式
            ,paymenttype -- 支付方式
            ,businessflag -- 授信/用信标志(1-授信;2-用信)
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,creditno -- 资方授信编号
            ,ordertype -- 资产类型
            ,repaytype -- 还款方式
            ,fixedbillday -- 固定出账日
            ,fixedrepayday -- 固定还款日
            ,loanterm -- 借款期数
            ,settlerate -- 结算利率
            ,loanuse -- 申请贷款用途
            ,debitaccountname -- 借款人收款户名
            ,debitopenaccountbank -- 收款人银行卡开户行
            ,debitaccountno -- 收款人银行卡卡号
            ,debitcnaps -- 收款卡联行号
            ,insureid -- 担保编号
            ,manualapproval -- 是否人工审批标识
            ,finaldecisioncode -- 最终决策结果标识
            ,finalapplyamount -- 最终审批额度(元)
            ,finalapplyterm -- 最终审批期限
            ,finalapplyvaluation -- 最终评估价格(元)
            ,risknote -- 风控备注
            ,riskwarm -- 风控预警
            ,educationlevel -- 教育水平
            ,monthlyincome -- 月收入
            ,providentfundbaseamt -- 公积金缴纳基数
            ,securitybaseamt -- 社保缴纳基数
            ,providentfundcompany -- 公积金缴纳单位
            ,companyaddr -- 单位地址
            ,recterm -- 推荐期限
            ,finishtime -- 审批完成时间
            ,userrating -- 乐信用户评级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 授信申请编号
    ,o.creditapplyid -- 乐信的申请编号(资产号)
    ,o.partnercode -- 合作方代码
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.creditamount -- 授信金额(元)
    ,o.maritalstatus -- 婚姻状况
    ,o.age -- 年龄
    ,o.sex -- 性别
    ,o.identitype -- 证件类型
    ,o.identino -- 证件号码
    ,o.idcardexpiredate -- 身份证有效期止
    ,o.idcardvaliddate -- 身份证有效期起
    ,o.idaddr -- 身份证地址
    ,o.issuedagency -- 身份证签发机关
    ,o.birthday -- 出生日期
    ,o.nationality -- 国籍
    ,o.nation -- 民族
    ,o.mobileno -- 客户手机号
    ,o.userbankcardno -- 用户银行卡号
    ,o.fstlnkmname -- 第一联系人姓名
    ,o.fstlnkmtel -- 第一联系人手机
    ,o.frslnkmrela -- 第一联系人关系
    ,o.livingaddress -- 居住地址
    ,o.useroccupation -- 客户职业
    ,o.userindustrycategory -- 客户行业
    ,o.extend -- 扩展信息
    ,o.auditstatus -- 授信审核状态
    ,o.approvestatus -- 审批状态
    ,o.productid -- 产品编号
    ,o.vouchtype -- 担保方式
    ,o.paymenttype -- 支付方式
    ,o.businessflag -- 授信/用信标志(1-授信;2-用信)
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.creditno -- 资方授信编号
    ,o.ordertype -- 资产类型
    ,o.repaytype -- 还款方式
    ,o.fixedbillday -- 固定出账日
    ,o.fixedrepayday -- 固定还款日
    ,o.loanterm -- 借款期数
    ,o.settlerate -- 结算利率
    ,o.loanuse -- 申请贷款用途
    ,o.debitaccountname -- 借款人收款户名
    ,o.debitopenaccountbank -- 收款人银行卡开户行
    ,o.debitaccountno -- 收款人银行卡卡号
    ,o.debitcnaps -- 收款卡联行号
    ,o.insureid -- 担保编号
    ,o.manualapproval -- 是否人工审批标识
    ,o.finaldecisioncode -- 最终决策结果标识
    ,o.finalapplyamount -- 最终审批额度(元)
    ,o.finalapplyterm -- 最终审批期限
    ,o.finalapplyvaluation -- 最终评估价格(元)
    ,o.risknote -- 风控备注
    ,o.riskwarm -- 风控预警
    ,o.educationlevel -- 教育水平
    ,o.monthlyincome -- 月收入
    ,o.providentfundbaseamt -- 公积金缴纳基数
    ,o.securitybaseamt -- 社保缴纳基数
    ,o.providentfundcompany -- 公积金缴纳单位
    ,o.companyaddr -- 单位地址
    ,o.recterm -- 推荐期限
    ,o.finishtime -- 审批完成时间
    ,o.userrating -- 乐信用户评级
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_lx_business_apply_bk o
    left join ${iol_schema}.icms_lx_business_apply_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_lx_business_apply_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_lx_business_apply;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_lx_business_apply') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_lx_business_apply drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_lx_business_apply add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_lx_business_apply exchange partition p_${batch_date} with table ${iol_schema}.icms_lx_business_apply_cl;
alter table ${iol_schema}.icms_lx_business_apply exchange partition p_20991231 with table ${iol_schema}.icms_lx_business_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lx_business_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lx_business_apply_op purge;
drop table ${iol_schema}.icms_lx_business_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_lx_business_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lx_business_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
