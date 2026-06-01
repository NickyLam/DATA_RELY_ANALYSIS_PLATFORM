/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_myhb_iqp_loan_app
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
create table ${iol_schema}.icms_myhb_iqp_loan_app_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_myhb_iqp_loan_app
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myhb_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_myhb_iqp_loan_app_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myhb_iqp_loan_app_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_myhb_iqp_loan_app where 0=1;

create table ${iol_schema}.icms_myhb_iqp_loan_app_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_myhb_iqp_loan_app where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_myhb_iqp_loan_app_cl(
            serialno -- 业务流水号
            ,validityofprod -- 协议有效期
            ,lastadvicedate -- 终审通知时间
            ,migtflag -- 
            ,applydate -- 申请日期
            ,approvestatus -- 审批状态
            ,cusmgr -- 客户经理
            ,sexnew -- 新性别
            ,certtype -- 证件类型
            ,applyamount -- 审批额度(元)
            ,riskrating -- 风险评级
            ,cusid -- 客户号
            ,startdate -- 审批开始时间
            ,prdcode -- 产品编号
            ,certcodenew -- 新证件号码
            ,hashbadmit -- 是否之前就有花呗额度
            ,enddate -- 审批结束时间
            ,instcode -- 推荐方机构ID
            ,ischeckrule -- 准入规则校验结果
            ,zmauthflag -- 芝麻授权成功表示
            ,platformaccess -- 蚂蚁金服审批结果
            ,validdatestartnew -- 新证件有效期起始日
            ,addressnew -- 新地址
            ,mobileno -- 手机号
            ,joininstcodes -- 参与联合审批机构ID列表
            ,nationalitynew -- 新国籍
            ,rulingir -- 日利率
            ,agreementno -- 协议编号
            ,certcode -- 证件号码
            ,solvencyratings -- 偿债能力评级
            ,invitestatus -- 邀约是否通过
            ,closetime -- 用户解约的具体时间
            ,mngbrid -- 主管机构
            ,certtypenew -- 新证件类型
            ,applyno -- 蚂蚁申请单号
            ,platformmaxamt -- 最大额度(元)
            ,platformrefusereason -- 蚂蚁金服拒绝原因
            ,ratetype -- 利率类型1基准利率2LPR
            ,professionnew -- 新职业
            ,failreason -- 拒绝原因
            ,changeresultreason -- 额度、定价变更原因
            ,refusereason -- 返回蚂蚁花呗的拒绝原因
            ,cusnamenew -- 新姓名
            ,certvalidenddate -- 证件有效期
            ,contracttext -- 缔约文本
            ,validdateendnew -- 新证件有效期到期日
            ,telenew -- 新联系方式
            ,approveprogress -- 进度说明
            ,cusname -- 姓名
            ,authtext -- 用户授权协议概要信息
            ,consumingscore -- 消费能力评分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_myhb_iqp_loan_app_op(
            serialno -- 业务流水号
            ,validityofprod -- 协议有效期
            ,lastadvicedate -- 终审通知时间
            ,migtflag -- 
            ,applydate -- 申请日期
            ,approvestatus -- 审批状态
            ,cusmgr -- 客户经理
            ,sexnew -- 新性别
            ,certtype -- 证件类型
            ,applyamount -- 审批额度(元)
            ,riskrating -- 风险评级
            ,cusid -- 客户号
            ,startdate -- 审批开始时间
            ,prdcode -- 产品编号
            ,certcodenew -- 新证件号码
            ,hashbadmit -- 是否之前就有花呗额度
            ,enddate -- 审批结束时间
            ,instcode -- 推荐方机构ID
            ,ischeckrule -- 准入规则校验结果
            ,zmauthflag -- 芝麻授权成功表示
            ,platformaccess -- 蚂蚁金服审批结果
            ,validdatestartnew -- 新证件有效期起始日
            ,addressnew -- 新地址
            ,mobileno -- 手机号
            ,joininstcodes -- 参与联合审批机构ID列表
            ,nationalitynew -- 新国籍
            ,rulingir -- 日利率
            ,agreementno -- 协议编号
            ,certcode -- 证件号码
            ,solvencyratings -- 偿债能力评级
            ,invitestatus -- 邀约是否通过
            ,closetime -- 用户解约的具体时间
            ,mngbrid -- 主管机构
            ,certtypenew -- 新证件类型
            ,applyno -- 蚂蚁申请单号
            ,platformmaxamt -- 最大额度(元)
            ,platformrefusereason -- 蚂蚁金服拒绝原因
            ,ratetype -- 利率类型1基准利率2LPR
            ,professionnew -- 新职业
            ,failreason -- 拒绝原因
            ,changeresultreason -- 额度、定价变更原因
            ,refusereason -- 返回蚂蚁花呗的拒绝原因
            ,cusnamenew -- 新姓名
            ,certvalidenddate -- 证件有效期
            ,contracttext -- 缔约文本
            ,validdateendnew -- 新证件有效期到期日
            ,telenew -- 新联系方式
            ,approveprogress -- 进度说明
            ,cusname -- 姓名
            ,authtext -- 用户授权协议概要信息
            ,consumingscore -- 消费能力评分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 业务流水号
    ,nvl(n.validityofprod, o.validityofprod) as validityofprod -- 协议有效期
    ,nvl(n.lastadvicedate, o.lastadvicedate) as lastadvicedate -- 终审通知时间
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.applydate, o.applydate) as applydate -- 申请日期
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.cusmgr, o.cusmgr) as cusmgr -- 客户经理
    ,nvl(n.sexnew, o.sexnew) as sexnew -- 新性别
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.applyamount, o.applyamount) as applyamount -- 审批额度(元)
    ,nvl(n.riskrating, o.riskrating) as riskrating -- 风险评级
    ,nvl(n.cusid, o.cusid) as cusid -- 客户号
    ,nvl(n.startdate, o.startdate) as startdate -- 审批开始时间
    ,nvl(n.prdcode, o.prdcode) as prdcode -- 产品编号
    ,nvl(n.certcodenew, o.certcodenew) as certcodenew -- 新证件号码
    ,nvl(n.hashbadmit, o.hashbadmit) as hashbadmit -- 是否之前就有花呗额度
    ,nvl(n.enddate, o.enddate) as enddate -- 审批结束时间
    ,nvl(n.instcode, o.instcode) as instcode -- 推荐方机构ID
    ,nvl(n.ischeckrule, o.ischeckrule) as ischeckrule -- 准入规则校验结果
    ,nvl(n.zmauthflag, o.zmauthflag) as zmauthflag -- 芝麻授权成功表示
    ,nvl(n.platformaccess, o.platformaccess) as platformaccess -- 蚂蚁金服审批结果
    ,nvl(n.validdatestartnew, o.validdatestartnew) as validdatestartnew -- 新证件有效期起始日
    ,nvl(n.addressnew, o.addressnew) as addressnew -- 新地址
    ,nvl(n.mobileno, o.mobileno) as mobileno -- 手机号
    ,nvl(n.joininstcodes, o.joininstcodes) as joininstcodes -- 参与联合审批机构ID列表
    ,nvl(n.nationalitynew, o.nationalitynew) as nationalitynew -- 新国籍
    ,nvl(n.rulingir, o.rulingir) as rulingir -- 日利率
    ,nvl(n.agreementno, o.agreementno) as agreementno -- 协议编号
    ,nvl(n.certcode, o.certcode) as certcode -- 证件号码
    ,nvl(n.solvencyratings, o.solvencyratings) as solvencyratings -- 偿债能力评级
    ,nvl(n.invitestatus, o.invitestatus) as invitestatus -- 邀约是否通过
    ,nvl(n.closetime, o.closetime) as closetime -- 用户解约的具体时间
    ,nvl(n.mngbrid, o.mngbrid) as mngbrid -- 主管机构
    ,nvl(n.certtypenew, o.certtypenew) as certtypenew -- 新证件类型
    ,nvl(n.applyno, o.applyno) as applyno -- 蚂蚁申请单号
    ,nvl(n.platformmaxamt, o.platformmaxamt) as platformmaxamt -- 最大额度(元)
    ,nvl(n.platformrefusereason, o.platformrefusereason) as platformrefusereason -- 蚂蚁金服拒绝原因
    ,nvl(n.ratetype, o.ratetype) as ratetype -- 利率类型1基准利率2LPR
    ,nvl(n.professionnew, o.professionnew) as professionnew -- 新职业
    ,nvl(n.failreason, o.failreason) as failreason -- 拒绝原因
    ,nvl(n.changeresultreason, o.changeresultreason) as changeresultreason -- 额度、定价变更原因
    ,nvl(n.refusereason, o.refusereason) as refusereason -- 返回蚂蚁花呗的拒绝原因
    ,nvl(n.cusnamenew, o.cusnamenew) as cusnamenew -- 新姓名
    ,nvl(n.certvalidenddate, o.certvalidenddate) as certvalidenddate -- 证件有效期
    ,nvl(n.contracttext, o.contracttext) as contracttext -- 缔约文本
    ,nvl(n.validdateendnew, o.validdateendnew) as validdateendnew -- 新证件有效期到期日
    ,nvl(n.telenew, o.telenew) as telenew -- 新联系方式
    ,nvl(n.approveprogress, o.approveprogress) as approveprogress -- 进度说明
    ,nvl(n.cusname, o.cusname) as cusname -- 姓名
    ,nvl(n.authtext, o.authtext) as authtext -- 用户授权协议概要信息
    ,nvl(n.consumingscore, o.consumingscore) as consumingscore -- 消费能力评分
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
from (select * from ${iol_schema}.icms_myhb_iqp_loan_app_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_myhb_iqp_loan_app where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.validityofprod <> n.validityofprod
        or o.lastadvicedate <> n.lastadvicedate
        or o.migtflag <> n.migtflag
        or o.applydate <> n.applydate
        or o.approvestatus <> n.approvestatus
        or o.cusmgr <> n.cusmgr
        or o.sexnew <> n.sexnew
        or o.certtype <> n.certtype
        or o.applyamount <> n.applyamount
        or o.riskrating <> n.riskrating
        or o.cusid <> n.cusid
        or o.startdate <> n.startdate
        or o.prdcode <> n.prdcode
        or o.certcodenew <> n.certcodenew
        or o.hashbadmit <> n.hashbadmit
        or o.enddate <> n.enddate
        or o.instcode <> n.instcode
        or o.ischeckrule <> n.ischeckrule
        or o.zmauthflag <> n.zmauthflag
        or o.platformaccess <> n.platformaccess
        or o.validdatestartnew <> n.validdatestartnew
        or o.addressnew <> n.addressnew
        or o.mobileno <> n.mobileno
        or o.joininstcodes <> n.joininstcodes
        or o.nationalitynew <> n.nationalitynew
        or o.rulingir <> n.rulingir
        or o.agreementno <> n.agreementno
        or o.certcode <> n.certcode
        or o.solvencyratings <> n.solvencyratings
        or o.invitestatus <> n.invitestatus
        or o.closetime <> n.closetime
        or o.mngbrid <> n.mngbrid
        or o.certtypenew <> n.certtypenew
        or o.applyno <> n.applyno
        or o.platformmaxamt <> n.platformmaxamt
        or o.platformrefusereason <> n.platformrefusereason
        or o.ratetype <> n.ratetype
        or o.professionnew <> n.professionnew
        or o.failreason <> n.failreason
        or o.changeresultreason <> n.changeresultreason
        or o.refusereason <> n.refusereason
        or o.cusnamenew <> n.cusnamenew
        or o.certvalidenddate <> n.certvalidenddate
        or o.contracttext <> n.contracttext
        or o.validdateendnew <> n.validdateendnew
        or o.telenew <> n.telenew
        or o.approveprogress <> n.approveprogress
        or o.cusname <> n.cusname
        or o.authtext <> n.authtext
        or o.consumingscore <> n.consumingscore
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_myhb_iqp_loan_app_cl(
            serialno -- 业务流水号
            ,validityofprod -- 协议有效期
            ,lastadvicedate -- 终审通知时间
            ,migtflag -- 
            ,applydate -- 申请日期
            ,approvestatus -- 审批状态
            ,cusmgr -- 客户经理
            ,sexnew -- 新性别
            ,certtype -- 证件类型
            ,applyamount -- 审批额度(元)
            ,riskrating -- 风险评级
            ,cusid -- 客户号
            ,startdate -- 审批开始时间
            ,prdcode -- 产品编号
            ,certcodenew -- 新证件号码
            ,hashbadmit -- 是否之前就有花呗额度
            ,enddate -- 审批结束时间
            ,instcode -- 推荐方机构ID
            ,ischeckrule -- 准入规则校验结果
            ,zmauthflag -- 芝麻授权成功表示
            ,platformaccess -- 蚂蚁金服审批结果
            ,validdatestartnew -- 新证件有效期起始日
            ,addressnew -- 新地址
            ,mobileno -- 手机号
            ,joininstcodes -- 参与联合审批机构ID列表
            ,nationalitynew -- 新国籍
            ,rulingir -- 日利率
            ,agreementno -- 协议编号
            ,certcode -- 证件号码
            ,solvencyratings -- 偿债能力评级
            ,invitestatus -- 邀约是否通过
            ,closetime -- 用户解约的具体时间
            ,mngbrid -- 主管机构
            ,certtypenew -- 新证件类型
            ,applyno -- 蚂蚁申请单号
            ,platformmaxamt -- 最大额度(元)
            ,platformrefusereason -- 蚂蚁金服拒绝原因
            ,ratetype -- 利率类型1基准利率2LPR
            ,professionnew -- 新职业
            ,failreason -- 拒绝原因
            ,changeresultreason -- 额度、定价变更原因
            ,refusereason -- 返回蚂蚁花呗的拒绝原因
            ,cusnamenew -- 新姓名
            ,certvalidenddate -- 证件有效期
            ,contracttext -- 缔约文本
            ,validdateendnew -- 新证件有效期到期日
            ,telenew -- 新联系方式
            ,approveprogress -- 进度说明
            ,cusname -- 姓名
            ,authtext -- 用户授权协议概要信息
            ,consumingscore -- 消费能力评分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_myhb_iqp_loan_app_op(
            serialno -- 业务流水号
            ,validityofprod -- 协议有效期
            ,lastadvicedate -- 终审通知时间
            ,migtflag -- 
            ,applydate -- 申请日期
            ,approvestatus -- 审批状态
            ,cusmgr -- 客户经理
            ,sexnew -- 新性别
            ,certtype -- 证件类型
            ,applyamount -- 审批额度(元)
            ,riskrating -- 风险评级
            ,cusid -- 客户号
            ,startdate -- 审批开始时间
            ,prdcode -- 产品编号
            ,certcodenew -- 新证件号码
            ,hashbadmit -- 是否之前就有花呗额度
            ,enddate -- 审批结束时间
            ,instcode -- 推荐方机构ID
            ,ischeckrule -- 准入规则校验结果
            ,zmauthflag -- 芝麻授权成功表示
            ,platformaccess -- 蚂蚁金服审批结果
            ,validdatestartnew -- 新证件有效期起始日
            ,addressnew -- 新地址
            ,mobileno -- 手机号
            ,joininstcodes -- 参与联合审批机构ID列表
            ,nationalitynew -- 新国籍
            ,rulingir -- 日利率
            ,agreementno -- 协议编号
            ,certcode -- 证件号码
            ,solvencyratings -- 偿债能力评级
            ,invitestatus -- 邀约是否通过
            ,closetime -- 用户解约的具体时间
            ,mngbrid -- 主管机构
            ,certtypenew -- 新证件类型
            ,applyno -- 蚂蚁申请单号
            ,platformmaxamt -- 最大额度(元)
            ,platformrefusereason -- 蚂蚁金服拒绝原因
            ,ratetype -- 利率类型1基准利率2LPR
            ,professionnew -- 新职业
            ,failreason -- 拒绝原因
            ,changeresultreason -- 额度、定价变更原因
            ,refusereason -- 返回蚂蚁花呗的拒绝原因
            ,cusnamenew -- 新姓名
            ,certvalidenddate -- 证件有效期
            ,contracttext -- 缔约文本
            ,validdateendnew -- 新证件有效期到期日
            ,telenew -- 新联系方式
            ,approveprogress -- 进度说明
            ,cusname -- 姓名
            ,authtext -- 用户授权协议概要信息
            ,consumingscore -- 消费能力评分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 业务流水号
    ,o.validityofprod -- 协议有效期
    ,o.lastadvicedate -- 终审通知时间
    ,o.migtflag -- 
    ,o.applydate -- 申请日期
    ,o.approvestatus -- 审批状态
    ,o.cusmgr -- 客户经理
    ,o.sexnew -- 新性别
    ,o.certtype -- 证件类型
    ,o.applyamount -- 审批额度(元)
    ,o.riskrating -- 风险评级
    ,o.cusid -- 客户号
    ,o.startdate -- 审批开始时间
    ,o.prdcode -- 产品编号
    ,o.certcodenew -- 新证件号码
    ,o.hashbadmit -- 是否之前就有花呗额度
    ,o.enddate -- 审批结束时间
    ,o.instcode -- 推荐方机构ID
    ,o.ischeckrule -- 准入规则校验结果
    ,o.zmauthflag -- 芝麻授权成功表示
    ,o.platformaccess -- 蚂蚁金服审批结果
    ,o.validdatestartnew -- 新证件有效期起始日
    ,o.addressnew -- 新地址
    ,o.mobileno -- 手机号
    ,o.joininstcodes -- 参与联合审批机构ID列表
    ,o.nationalitynew -- 新国籍
    ,o.rulingir -- 日利率
    ,o.agreementno -- 协议编号
    ,o.certcode -- 证件号码
    ,o.solvencyratings -- 偿债能力评级
    ,o.invitestatus -- 邀约是否通过
    ,o.closetime -- 用户解约的具体时间
    ,o.mngbrid -- 主管机构
    ,o.certtypenew -- 新证件类型
    ,o.applyno -- 蚂蚁申请单号
    ,o.platformmaxamt -- 最大额度(元)
    ,o.platformrefusereason -- 蚂蚁金服拒绝原因
    ,o.ratetype -- 利率类型1基准利率2LPR
    ,o.professionnew -- 新职业
    ,o.failreason -- 拒绝原因
    ,o.changeresultreason -- 额度、定价变更原因
    ,o.refusereason -- 返回蚂蚁花呗的拒绝原因
    ,o.cusnamenew -- 新姓名
    ,o.certvalidenddate -- 证件有效期
    ,o.contracttext -- 缔约文本
    ,o.validdateendnew -- 新证件有效期到期日
    ,o.telenew -- 新联系方式
    ,o.approveprogress -- 进度说明
    ,o.cusname -- 姓名
    ,o.authtext -- 用户授权协议概要信息
    ,o.consumingscore -- 消费能力评分
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
from ${iol_schema}.icms_myhb_iqp_loan_app_bk o
    left join ${iol_schema}.icms_myhb_iqp_loan_app_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_myhb_iqp_loan_app_cl d
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
--truncate table ${iol_schema}.icms_myhb_iqp_loan_app;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_myhb_iqp_loan_app') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_myhb_iqp_loan_app drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_myhb_iqp_loan_app add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_myhb_iqp_loan_app exchange partition p_${batch_date} with table ${iol_schema}.icms_myhb_iqp_loan_app_cl;
alter table ${iol_schema}.icms_myhb_iqp_loan_app exchange partition p_20991231 with table ${iol_schema}.icms_myhb_iqp_loan_app_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_myhb_iqp_loan_app to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myhb_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_myhb_iqp_loan_app_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_myhb_iqp_loan_app_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_myhb_iqp_loan_app',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
