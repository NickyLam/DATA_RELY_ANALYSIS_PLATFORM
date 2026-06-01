/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_afterloan_write_off
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
create table ${iol_schema}.icms_afterloan_write_off_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_afterloan_write_off
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_afterloan_write_off_op purge;
drop table ${iol_schema}.icms_afterloan_write_off_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_afterloan_write_off_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_afterloan_write_off where 0=1;

create table ${iol_schema}.icms_afterloan_write_off_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_afterloan_write_off where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_afterloan_write_off_cl(
            serialno -- 业务流水号
            ,cancelrecein -- 核销表内利息
            ,claimsrecoverygrt -- 保证人、抵押/质押物追偿情况及结果
            ,claimsrecoveryborrower -- 借款人（或股权）追偿情况及结果
            ,customerid -- 客户号
            ,cussex -- 性别
            ,borrowercriminalnumber -- 借款人被判触犯刑律文号
            ,courtfinarulingtime -- 法院最终裁定时间
            ,dzhxbatchno -- 呆账核销批次号
            ,batsubtype -- 业务子类
            ,loanbalance -- 贷款余额
            ,amt -- 本金
            ,customername -- 客户名称
            ,borrowercriminaltime -- 借款人被判触犯刑律时间
            ,otherprooftime -- 其他形式证明时间
            ,approveverificationperiod -- 审批核销日期
            ,courtfinarulingtitle -- 法院最终裁定文件名
            ,inputuserid -- 登记人
            ,cancelcurtype -- 核销金额币种
            ,baddebtscausereason -- 呆账形成原因
            ,inputdate -- 登记日期
            ,certid -- 证件号码
            ,canceltype -- 核销类别
            ,responsibilityidentifyresult -- 责任认定及责任认定处理结果
            ,curtype -- 币种
            ,approvehxininterest -- 审批核销表内利息
            ,inputorgid -- 登记机构
            ,courtfinarulingnumber -- 法院最终裁定文号
            ,cancelamount -- 核销本金
            ,otherprooftitle -- 其他形式证明文件名
            ,approvedate -- 核销日期
            ,finabrid -- 账务机构
            ,certtype -- 证件类型
            ,approveamt -- 核销金额
            ,approvehxoutinterest -- 审批核销表外利息
            ,accids -- 借据编号集合
            ,cusmarst -- 婚姻状况
            ,approvestatus -- 审批状态
            ,borrowerbusicodecanceltime -- 工商部门注销（或吊销）借款人营业执照时间
            ,uplproductid -- 微贷业务品种
            ,compname -- 经营企业名称
            ,isretainrecourse -- 是否保留对债务人的追索权
            ,cancelreceout -- 核销表外利息
            ,borrowercriminaltitle -- 借款人被判触犯刑律文件名
            ,advancepayment -- 垫付费用
            ,otherproofnumber -- 其他形式证明文号
            ,industry -- 所属行业
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,exposureamount -- 敞口金额
            ,advancepatotal -- 总垫付金额
            ,completeflag -- 数据录入完整性标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_afterloan_write_off_op(
            serialno -- 业务流水号
            ,cancelrecein -- 核销表内利息
            ,claimsrecoverygrt -- 保证人、抵押/质押物追偿情况及结果
            ,claimsrecoveryborrower -- 借款人（或股权）追偿情况及结果
            ,customerid -- 客户号
            ,cussex -- 性别
            ,borrowercriminalnumber -- 借款人被判触犯刑律文号
            ,courtfinarulingtime -- 法院最终裁定时间
            ,dzhxbatchno -- 呆账核销批次号
            ,batsubtype -- 业务子类
            ,loanbalance -- 贷款余额
            ,amt -- 本金
            ,customername -- 客户名称
            ,borrowercriminaltime -- 借款人被判触犯刑律时间
            ,otherprooftime -- 其他形式证明时间
            ,approveverificationperiod -- 审批核销日期
            ,courtfinarulingtitle -- 法院最终裁定文件名
            ,inputuserid -- 登记人
            ,cancelcurtype -- 核销金额币种
            ,baddebtscausereason -- 呆账形成原因
            ,inputdate -- 登记日期
            ,certid -- 证件号码
            ,canceltype -- 核销类别
            ,responsibilityidentifyresult -- 责任认定及责任认定处理结果
            ,curtype -- 币种
            ,approvehxininterest -- 审批核销表内利息
            ,inputorgid -- 登记机构
            ,courtfinarulingnumber -- 法院最终裁定文号
            ,cancelamount -- 核销本金
            ,otherprooftitle -- 其他形式证明文件名
            ,approvedate -- 核销日期
            ,finabrid -- 账务机构
            ,certtype -- 证件类型
            ,approveamt -- 核销金额
            ,approvehxoutinterest -- 审批核销表外利息
            ,accids -- 借据编号集合
            ,cusmarst -- 婚姻状况
            ,approvestatus -- 审批状态
            ,borrowerbusicodecanceltime -- 工商部门注销（或吊销）借款人营业执照时间
            ,uplproductid -- 微贷业务品种
            ,compname -- 经营企业名称
            ,isretainrecourse -- 是否保留对债务人的追索权
            ,cancelreceout -- 核销表外利息
            ,borrowercriminaltitle -- 借款人被判触犯刑律文件名
            ,advancepayment -- 垫付费用
            ,otherproofnumber -- 其他形式证明文号
            ,industry -- 所属行业
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,exposureamount -- 敞口金额
            ,advancepatotal -- 总垫付金额
            ,completeflag -- 数据录入完整性标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 业务流水号
    ,nvl(n.cancelrecein, o.cancelrecein) as cancelrecein -- 核销表内利息
    ,nvl(n.claimsrecoverygrt, o.claimsrecoverygrt) as claimsrecoverygrt -- 保证人、抵押/质押物追偿情况及结果
    ,nvl(n.claimsrecoveryborrower, o.claimsrecoveryborrower) as claimsrecoveryborrower -- 借款人（或股权）追偿情况及结果
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.cussex, o.cussex) as cussex -- 性别
    ,nvl(n.borrowercriminalnumber, o.borrowercriminalnumber) as borrowercriminalnumber -- 借款人被判触犯刑律文号
    ,nvl(n.courtfinarulingtime, o.courtfinarulingtime) as courtfinarulingtime -- 法院最终裁定时间
    ,nvl(n.dzhxbatchno, o.dzhxbatchno) as dzhxbatchno -- 呆账核销批次号
    ,nvl(n.batsubtype, o.batsubtype) as batsubtype -- 业务子类
    ,nvl(n.loanbalance, o.loanbalance) as loanbalance -- 贷款余额
    ,nvl(n.amt, o.amt) as amt -- 本金
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.borrowercriminaltime, o.borrowercriminaltime) as borrowercriminaltime -- 借款人被判触犯刑律时间
    ,nvl(n.otherprooftime, o.otherprooftime) as otherprooftime -- 其他形式证明时间
    ,nvl(n.approveverificationperiod, o.approveverificationperiod) as approveverificationperiod -- 审批核销日期
    ,nvl(n.courtfinarulingtitle, o.courtfinarulingtitle) as courtfinarulingtitle -- 法院最终裁定文件名
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.cancelcurtype, o.cancelcurtype) as cancelcurtype -- 核销金额币种
    ,nvl(n.baddebtscausereason, o.baddebtscausereason) as baddebtscausereason -- 呆账形成原因
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.canceltype, o.canceltype) as canceltype -- 核销类别
    ,nvl(n.responsibilityidentifyresult, o.responsibilityidentifyresult) as responsibilityidentifyresult -- 责任认定及责任认定处理结果
    ,nvl(n.curtype, o.curtype) as curtype -- 币种
    ,nvl(n.approvehxininterest, o.approvehxininterest) as approvehxininterest -- 审批核销表内利息
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.courtfinarulingnumber, o.courtfinarulingnumber) as courtfinarulingnumber -- 法院最终裁定文号
    ,nvl(n.cancelamount, o.cancelamount) as cancelamount -- 核销本金
    ,nvl(n.otherprooftitle, o.otherprooftitle) as otherprooftitle -- 其他形式证明文件名
    ,nvl(n.approvedate, o.approvedate) as approvedate -- 核销日期
    ,nvl(n.finabrid, o.finabrid) as finabrid -- 账务机构
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.approveamt, o.approveamt) as approveamt -- 核销金额
    ,nvl(n.approvehxoutinterest, o.approvehxoutinterest) as approvehxoutinterest -- 审批核销表外利息
    ,nvl(n.accids, o.accids) as accids -- 借据编号集合
    ,nvl(n.cusmarst, o.cusmarst) as cusmarst -- 婚姻状况
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.borrowerbusicodecanceltime, o.borrowerbusicodecanceltime) as borrowerbusicodecanceltime -- 工商部门注销（或吊销）借款人营业执照时间
    ,nvl(n.uplproductid, o.uplproductid) as uplproductid -- 微贷业务品种
    ,nvl(n.compname, o.compname) as compname -- 经营企业名称
    ,nvl(n.isretainrecourse, o.isretainrecourse) as isretainrecourse -- 是否保留对债务人的追索权
    ,nvl(n.cancelreceout, o.cancelreceout) as cancelreceout -- 核销表外利息
    ,nvl(n.borrowercriminaltitle, o.borrowercriminaltitle) as borrowercriminaltitle -- 借款人被判触犯刑律文件名
    ,nvl(n.advancepayment, o.advancepayment) as advancepayment -- 垫付费用
    ,nvl(n.otherproofnumber, o.otherproofnumber) as otherproofnumber -- 其他形式证明文号
    ,nvl(n.industry, o.industry) as industry -- 所属行业
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.exposureamount, o.exposureamount) as exposureamount -- 敞口金额
    ,nvl(n.advancepatotal, o.advancepatotal) as advancepatotal -- 总垫付金额
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 数据录入完整性标识
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
from (select * from ${iol_schema}.icms_afterloan_write_off_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_afterloan_write_off where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.cancelrecein <> n.cancelrecein
        or o.claimsrecoverygrt <> n.claimsrecoverygrt
        or o.claimsrecoveryborrower <> n.claimsrecoveryborrower
        or o.customerid <> n.customerid
        or o.cussex <> n.cussex
        or o.borrowercriminalnumber <> n.borrowercriminalnumber
        or o.courtfinarulingtime <> n.courtfinarulingtime
        or o.dzhxbatchno <> n.dzhxbatchno
        or o.batsubtype <> n.batsubtype
        or o.loanbalance <> n.loanbalance
        or o.amt <> n.amt
        or o.customername <> n.customername
        or o.borrowercriminaltime <> n.borrowercriminaltime
        or o.otherprooftime <> n.otherprooftime
        or o.approveverificationperiod <> n.approveverificationperiod
        or o.courtfinarulingtitle <> n.courtfinarulingtitle
        or o.inputuserid <> n.inputuserid
        or o.cancelcurtype <> n.cancelcurtype
        or o.baddebtscausereason <> n.baddebtscausereason
        or o.inputdate <> n.inputdate
        or o.certid <> n.certid
        or o.canceltype <> n.canceltype
        or o.responsibilityidentifyresult <> n.responsibilityidentifyresult
        or o.curtype <> n.curtype
        or o.approvehxininterest <> n.approvehxininterest
        or o.inputorgid <> n.inputorgid
        or o.courtfinarulingnumber <> n.courtfinarulingnumber
        or o.cancelamount <> n.cancelamount
        or o.otherprooftitle <> n.otherprooftitle
        or o.approvedate <> n.approvedate
        or o.finabrid <> n.finabrid
        or o.certtype <> n.certtype
        or o.approveamt <> n.approveamt
        or o.approvehxoutinterest <> n.approvehxoutinterest
        or o.accids <> n.accids
        or o.cusmarst <> n.cusmarst
        or o.approvestatus <> n.approvestatus
        or o.borrowerbusicodecanceltime <> n.borrowerbusicodecanceltime
        or o.uplproductid <> n.uplproductid
        or o.compname <> n.compname
        or o.isretainrecourse <> n.isretainrecourse
        or o.cancelreceout <> n.cancelreceout
        or o.borrowercriminaltitle <> n.borrowercriminaltitle
        or o.advancepayment <> n.advancepayment
        or o.otherproofnumber <> n.otherproofnumber
        or o.industry <> n.industry
        or o.migtflag <> n.migtflag
        or o.exposureamount <> n.exposureamount
        or o.advancepatotal <> n.advancepatotal
        or o.completeflag <> n.completeflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_afterloan_write_off_cl(
            serialno -- 业务流水号
            ,cancelrecein -- 核销表内利息
            ,claimsrecoverygrt -- 保证人、抵押/质押物追偿情况及结果
            ,claimsrecoveryborrower -- 借款人（或股权）追偿情况及结果
            ,customerid -- 客户号
            ,cussex -- 性别
            ,borrowercriminalnumber -- 借款人被判触犯刑律文号
            ,courtfinarulingtime -- 法院最终裁定时间
            ,dzhxbatchno -- 呆账核销批次号
            ,batsubtype -- 业务子类
            ,loanbalance -- 贷款余额
            ,amt -- 本金
            ,customername -- 客户名称
            ,borrowercriminaltime -- 借款人被判触犯刑律时间
            ,otherprooftime -- 其他形式证明时间
            ,approveverificationperiod -- 审批核销日期
            ,courtfinarulingtitle -- 法院最终裁定文件名
            ,inputuserid -- 登记人
            ,cancelcurtype -- 核销金额币种
            ,baddebtscausereason -- 呆账形成原因
            ,inputdate -- 登记日期
            ,certid -- 证件号码
            ,canceltype -- 核销类别
            ,responsibilityidentifyresult -- 责任认定及责任认定处理结果
            ,curtype -- 币种
            ,approvehxininterest -- 审批核销表内利息
            ,inputorgid -- 登记机构
            ,courtfinarulingnumber -- 法院最终裁定文号
            ,cancelamount -- 核销本金
            ,otherprooftitle -- 其他形式证明文件名
            ,approvedate -- 核销日期
            ,finabrid -- 账务机构
            ,certtype -- 证件类型
            ,approveamt -- 核销金额
            ,approvehxoutinterest -- 审批核销表外利息
            ,accids -- 借据编号集合
            ,cusmarst -- 婚姻状况
            ,approvestatus -- 审批状态
            ,borrowerbusicodecanceltime -- 工商部门注销（或吊销）借款人营业执照时间
            ,uplproductid -- 微贷业务品种
            ,compname -- 经营企业名称
            ,isretainrecourse -- 是否保留对债务人的追索权
            ,cancelreceout -- 核销表外利息
            ,borrowercriminaltitle -- 借款人被判触犯刑律文件名
            ,advancepayment -- 垫付费用
            ,otherproofnumber -- 其他形式证明文号
            ,industry -- 所属行业
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,exposureamount -- 敞口金额
            ,advancepatotal -- 总垫付金额
            ,completeflag -- 数据录入完整性标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_afterloan_write_off_op(
            serialno -- 业务流水号
            ,cancelrecein -- 核销表内利息
            ,claimsrecoverygrt -- 保证人、抵押/质押物追偿情况及结果
            ,claimsrecoveryborrower -- 借款人（或股权）追偿情况及结果
            ,customerid -- 客户号
            ,cussex -- 性别
            ,borrowercriminalnumber -- 借款人被判触犯刑律文号
            ,courtfinarulingtime -- 法院最终裁定时间
            ,dzhxbatchno -- 呆账核销批次号
            ,batsubtype -- 业务子类
            ,loanbalance -- 贷款余额
            ,amt -- 本金
            ,customername -- 客户名称
            ,borrowercriminaltime -- 借款人被判触犯刑律时间
            ,otherprooftime -- 其他形式证明时间
            ,approveverificationperiod -- 审批核销日期
            ,courtfinarulingtitle -- 法院最终裁定文件名
            ,inputuserid -- 登记人
            ,cancelcurtype -- 核销金额币种
            ,baddebtscausereason -- 呆账形成原因
            ,inputdate -- 登记日期
            ,certid -- 证件号码
            ,canceltype -- 核销类别
            ,responsibilityidentifyresult -- 责任认定及责任认定处理结果
            ,curtype -- 币种
            ,approvehxininterest -- 审批核销表内利息
            ,inputorgid -- 登记机构
            ,courtfinarulingnumber -- 法院最终裁定文号
            ,cancelamount -- 核销本金
            ,otherprooftitle -- 其他形式证明文件名
            ,approvedate -- 核销日期
            ,finabrid -- 账务机构
            ,certtype -- 证件类型
            ,approveamt -- 核销金额
            ,approvehxoutinterest -- 审批核销表外利息
            ,accids -- 借据编号集合
            ,cusmarst -- 婚姻状况
            ,approvestatus -- 审批状态
            ,borrowerbusicodecanceltime -- 工商部门注销（或吊销）借款人营业执照时间
            ,uplproductid -- 微贷业务品种
            ,compname -- 经营企业名称
            ,isretainrecourse -- 是否保留对债务人的追索权
            ,cancelreceout -- 核销表外利息
            ,borrowercriminaltitle -- 借款人被判触犯刑律文件名
            ,advancepayment -- 垫付费用
            ,otherproofnumber -- 其他形式证明文号
            ,industry -- 所属行业
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,exposureamount -- 敞口金额
            ,advancepatotal -- 总垫付金额
            ,completeflag -- 数据录入完整性标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 业务流水号
    ,o.cancelrecein -- 核销表内利息
    ,o.claimsrecoverygrt -- 保证人、抵押/质押物追偿情况及结果
    ,o.claimsrecoveryborrower -- 借款人（或股权）追偿情况及结果
    ,o.customerid -- 客户号
    ,o.cussex -- 性别
    ,o.borrowercriminalnumber -- 借款人被判触犯刑律文号
    ,o.courtfinarulingtime -- 法院最终裁定时间
    ,o.dzhxbatchno -- 呆账核销批次号
    ,o.batsubtype -- 业务子类
    ,o.loanbalance -- 贷款余额
    ,o.amt -- 本金
    ,o.customername -- 客户名称
    ,o.borrowercriminaltime -- 借款人被判触犯刑律时间
    ,o.otherprooftime -- 其他形式证明时间
    ,o.approveverificationperiod -- 审批核销日期
    ,o.courtfinarulingtitle -- 法院最终裁定文件名
    ,o.inputuserid -- 登记人
    ,o.cancelcurtype -- 核销金额币种
    ,o.baddebtscausereason -- 呆账形成原因
    ,o.inputdate -- 登记日期
    ,o.certid -- 证件号码
    ,o.canceltype -- 核销类别
    ,o.responsibilityidentifyresult -- 责任认定及责任认定处理结果
    ,o.curtype -- 币种
    ,o.approvehxininterest -- 审批核销表内利息
    ,o.inputorgid -- 登记机构
    ,o.courtfinarulingnumber -- 法院最终裁定文号
    ,o.cancelamount -- 核销本金
    ,o.otherprooftitle -- 其他形式证明文件名
    ,o.approvedate -- 核销日期
    ,o.finabrid -- 账务机构
    ,o.certtype -- 证件类型
    ,o.approveamt -- 核销金额
    ,o.approvehxoutinterest -- 审批核销表外利息
    ,o.accids -- 借据编号集合
    ,o.cusmarst -- 婚姻状况
    ,o.approvestatus -- 审批状态
    ,o.borrowerbusicodecanceltime -- 工商部门注销（或吊销）借款人营业执照时间
    ,o.uplproductid -- 微贷业务品种
    ,o.compname -- 经营企业名称
    ,o.isretainrecourse -- 是否保留对债务人的追索权
    ,o.cancelreceout -- 核销表外利息
    ,o.borrowercriminaltitle -- 借款人被判触犯刑律文件名
    ,o.advancepayment -- 垫付费用
    ,o.otherproofnumber -- 其他形式证明文号
    ,o.industry -- 所属行业
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.exposureamount -- 敞口金额
    ,o.advancepatotal -- 总垫付金额
    ,o.completeflag -- 数据录入完整性标识
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
from ${iol_schema}.icms_afterloan_write_off_bk o
    left join ${iol_schema}.icms_afterloan_write_off_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_afterloan_write_off_cl d
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
--truncate table ${iol_schema}.icms_afterloan_write_off;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_afterloan_write_off') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_afterloan_write_off drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_afterloan_write_off add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_afterloan_write_off exchange partition p_${batch_date} with table ${iol_schema}.icms_afterloan_write_off_cl;
alter table ${iol_schema}.icms_afterloan_write_off exchange partition p_20991231 with table ${iol_schema}.icms_afterloan_write_off_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_afterloan_write_off to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_afterloan_write_off_op purge;
drop table ${iol_schema}.icms_afterloan_write_off_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_afterloan_write_off_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_afterloan_write_off',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
