/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_myjb_iqp_loan_app
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.icms_myjb_iqp_loan_app_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_myjb_iqp_loan_app
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myjb_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_myjb_iqp_loan_app_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myjb_iqp_loan_app_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_myjb_iqp_loan_app where 0=1;

create table ${iol_schema}.icms_myjb_iqp_loan_app_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_myjb_iqp_loan_app where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.icms_myjb_iqp_loan_app_op(
        serialno -- 流水号
        ,cusnamenew -- 新姓名
        ,certvalidenddate -- 证件有效期
        ,ischeckrule -- 反欺诈是否已校验标识
        ,lpr -- LPR
        ,ratefloatmode -- 利率浮动方式
        ,certtypenew -- 新证件类型
        ,requestid -- 请求流水号
        ,cusname -- 客户姓名
        ,rulingir -- 基准利率
        ,startdate -- 审批开始时间
        ,productcode -- 产品标识
        ,addressnew -- 新地址
        ,prdcode -- 产品编号
        ,prdname -- 产品名称
        ,certcode -- 证件号码
        ,sexnew -- 新性别
        ,professionnew -- 新职业
        ,riskrating -- 风险评级
        ,biztype -- 申请类型
        ,certtype -- 证件类型
        ,cardno -- 快捷卡卡号
        ,cusid -- 客户号
        ,isgetcuscode -- 是否开户成功
        ,floatratebp -- 利率浮动点差BP
        ,validdatestartnew -- 新证件有效期起始日
        ,applyno -- 授信申请单号
        ,isapplyscore -- 发送评分接口成功与否
        ,sysid -- 处理业务系统ID
        ,promotereason -- 调额的原因说明
        ,migtflag -- 迁移标志：crsrcrilcupl
        ,nationalitynew -- 新国籍
        ,source -- 申请来源
        ,bizmode -- 业务模式
        ,changeresultreason -- 额度、定价变更原因
        ,inputid -- 登记人
        ,isagree -- 借呗是否同意审批结果
        ,creditflag -- 当前用户授信标识
        ,failreason -- 备注信息
        ,resultcode -- 审批结果码
        ,iscollectcredit -- 个人征信采集成功与否
        ,ratetype -- 利率类型1基准2lpr
        ,mobileno -- 手机号
        ,modeltype -- 所属模块
        ,enddate -- 审批结束时间
        ,promotetype -- 调额的类型
        ,hasjbadmit -- 是否之前就有借呗额度
        ,solvencyratings -- 偿债能力评级
        ,applydate -- 申请日期
        ,expired -- 申请过期时间
        ,informflag -- 通知借呗成功与否
        ,inputbrid -- 登记机构
        ,iscreditadopted -- 征信规则校验结果
        ,zmauthflag -- 芝麻授权成功表示
        ,applyamount -- 审批额度(元)
        ,approvestatus -- 审批状态
        ,telenew -- 新联系方式
        ,resultmsg -- 审批结果描述
        ,autoscore -- 评分A卡评分
        ,execrate -- 执行年利率，借呗推送日利率X360
        ,expirydate -- 固化授信有效期
        ,lastadvicedate -- 终审通知时间
        ,certcodenew -- 新证件号码
        ,validdateendnew -- 新证件有效期到期日
        ,repaymode -- 还款方式
        ,isintercept -- 是否成功发起MQ
        ,creditno -- 授信编号
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.serialno -- 流水号
    ,n.cusnamenew -- 新姓名
    ,n.certvalidenddate -- 证件有效期
    ,n.ischeckrule -- 反欺诈是否已校验标识
    ,n.lpr -- LPR
    ,n.ratefloatmode -- 利率浮动方式
    ,n.certtypenew -- 新证件类型
    ,n.requestid -- 请求流水号
    ,n.cusname -- 客户姓名
    ,n.rulingir -- 基准利率
    ,n.startdate -- 审批开始时间
    ,n.productcode -- 产品标识
    ,n.addressnew -- 新地址
    ,n.prdcode -- 产品编号
    ,n.prdname -- 产品名称
    ,n.certcode -- 证件号码
    ,n.sexnew -- 新性别
    ,n.professionnew -- 新职业
    ,n.riskrating -- 风险评级
    ,n.biztype -- 申请类型
    ,n.certtype -- 证件类型
    ,n.cardno -- 快捷卡卡号
    ,n.cusid -- 客户号
    ,n.isgetcuscode -- 是否开户成功
    ,n.floatratebp -- 利率浮动点差BP
    ,n.validdatestartnew -- 新证件有效期起始日
    ,n.applyno -- 授信申请单号
    ,n.isapplyscore -- 发送评分接口成功与否
    ,n.sysid -- 处理业务系统ID
    ,n.promotereason -- 调额的原因说明
    ,n.migtflag -- 迁移标志：crsrcrilcupl
    ,n.nationalitynew -- 新国籍
    ,n.source -- 申请来源
    ,n.bizmode -- 业务模式
    ,n.changeresultreason -- 额度、定价变更原因
    ,n.inputid -- 登记人
    ,n.isagree -- 借呗是否同意审批结果
    ,n.creditflag -- 当前用户授信标识
    ,n.failreason -- 备注信息
    ,n.resultcode -- 审批结果码
    ,n.iscollectcredit -- 个人征信采集成功与否
    ,n.ratetype -- 利率类型1基准2lpr
    ,n.mobileno -- 手机号
    ,n.modeltype -- 所属模块
    ,n.enddate -- 审批结束时间
    ,n.promotetype -- 调额的类型
    ,n.hasjbadmit -- 是否之前就有借呗额度
    ,n.solvencyratings -- 偿债能力评级
    ,n.applydate -- 申请日期
    ,n.expired -- 申请过期时间
    ,n.informflag -- 通知借呗成功与否
    ,n.inputbrid -- 登记机构
    ,n.iscreditadopted -- 征信规则校验结果
    ,n.zmauthflag -- 芝麻授权成功表示
    ,n.applyamount -- 审批额度(元)
    ,n.approvestatus -- 审批状态
    ,n.telenew -- 新联系方式
    ,n.resultmsg -- 审批结果描述
    ,n.autoscore -- 评分A卡评分
    ,n.execrate -- 执行年利率，借呗推送日利率X360
    ,n.expirydate -- 固化授信有效期
    ,n.lastadvicedate -- 终审通知时间
    ,n.certcodenew -- 新证件号码
    ,n.validdateendnew -- 新证件有效期到期日
    ,n.repaymode -- 还款方式
    ,n.isintercept -- 是否成功发起MQ
    ,n.creditno -- 授信编号
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_myjb_iqp_loan_app_bk o
    right join (select * from ${itl_schema}.icms_myjb_iqp_loan_app where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        o.cusnamenew <> n.cusnamenew
        or o.certvalidenddate <> n.certvalidenddate
        or o.ischeckrule <> n.ischeckrule
        or o.lpr <> n.lpr
        or o.ratefloatmode <> n.ratefloatmode
        or o.certtypenew <> n.certtypenew
        or o.requestid <> n.requestid
        or o.cusname <> n.cusname
        or o.rulingir <> n.rulingir
        or o.startdate <> n.startdate
        or o.productcode <> n.productcode
        or o.addressnew <> n.addressnew
        or o.prdcode <> n.prdcode
        or o.prdname <> n.prdname
        or o.certcode <> n.certcode
        or o.sexnew <> n.sexnew
        or o.professionnew <> n.professionnew
        or o.riskrating <> n.riskrating
        or o.biztype <> n.biztype
        or o.certtype <> n.certtype
        or o.cardno <> n.cardno
        or o.cusid <> n.cusid
        or o.isgetcuscode <> n.isgetcuscode
        or o.floatratebp <> n.floatratebp
        or o.validdatestartnew <> n.validdatestartnew
        or o.applyno <> n.applyno
        or o.isapplyscore <> n.isapplyscore
        or o.sysid <> n.sysid
        or o.promotereason <> n.promotereason
        or o.migtflag <> n.migtflag
        or o.nationalitynew <> n.nationalitynew
        or o.source <> n.source
        or o.bizmode <> n.bizmode
        or o.changeresultreason <> n.changeresultreason
        or o.inputid <> n.inputid
        or o.isagree <> n.isagree
        or o.creditflag <> n.creditflag
        or o.failreason <> n.failreason
        or o.resultcode <> n.resultcode
        or o.iscollectcredit <> n.iscollectcredit
        or o.ratetype <> n.ratetype
        or o.mobileno <> n.mobileno
        or o.modeltype <> n.modeltype
        or o.enddate <> n.enddate
        or o.promotetype <> n.promotetype
        or o.hasjbadmit <> n.hasjbadmit
        or o.solvencyratings <> n.solvencyratings
        or o.applydate <> n.applydate
        or o.expired <> n.expired
        or o.informflag <> n.informflag
        or o.inputbrid <> n.inputbrid
        or o.iscreditadopted <> n.iscreditadopted
        or o.zmauthflag <> n.zmauthflag
        or o.applyamount <> n.applyamount
        or o.approvestatus <> n.approvestatus
        or o.telenew <> n.telenew
        or o.resultmsg <> n.resultmsg
        or o.autoscore <> n.autoscore
        or o.execrate <> n.execrate
        or o.expirydate <> n.expirydate
        or o.lastadvicedate <> n.lastadvicedate
        or o.certcodenew <> n.certcodenew
        or o.validdateendnew <> n.validdateendnew
        or o.repaymode <> n.repaymode
        or o.isintercept <> n.isintercept
        or o.creditno <> n.creditno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_myjb_iqp_loan_app_cl(
            serialno -- 流水号
        ,cusnamenew -- 新姓名
        ,certvalidenddate -- 证件有效期
        ,ischeckrule -- 反欺诈是否已校验标识
        ,lpr -- LPR
        ,ratefloatmode -- 利率浮动方式
        ,certtypenew -- 新证件类型
        ,requestid -- 请求流水号
        ,cusname -- 客户姓名
        ,rulingir -- 基准利率
        ,startdate -- 审批开始时间
        ,productcode -- 产品标识
        ,addressnew -- 新地址
        ,prdcode -- 产品编号
        ,prdname -- 产品名称
        ,certcode -- 证件号码
        ,sexnew -- 新性别
        ,professionnew -- 新职业
        ,riskrating -- 风险评级
        ,biztype -- 申请类型
        ,certtype -- 证件类型
        ,cardno -- 快捷卡卡号
        ,cusid -- 客户号
        ,isgetcuscode -- 是否开户成功
        ,floatratebp -- 利率浮动点差BP
        ,validdatestartnew -- 新证件有效期起始日
        ,applyno -- 授信申请单号
        ,isapplyscore -- 发送评分接口成功与否
        ,sysid -- 处理业务系统ID
        ,promotereason -- 调额的原因说明
        ,migtflag -- 迁移标志：crsrcrilcupl
        ,nationalitynew -- 新国籍
        ,source -- 申请来源
        ,bizmode -- 业务模式
        ,changeresultreason -- 额度、定价变更原因
        ,inputid -- 登记人
        ,isagree -- 借呗是否同意审批结果
        ,creditflag -- 当前用户授信标识
        ,failreason -- 备注信息
        ,resultcode -- 审批结果码
        ,iscollectcredit -- 个人征信采集成功与否
        ,ratetype -- 利率类型1基准2lpr
        ,mobileno -- 手机号
        ,modeltype -- 所属模块
        ,enddate -- 审批结束时间
        ,promotetype -- 调额的类型
        ,hasjbadmit -- 是否之前就有借呗额度
        ,solvencyratings -- 偿债能力评级
        ,applydate -- 申请日期
        ,expired -- 申请过期时间
        ,informflag -- 通知借呗成功与否
        ,inputbrid -- 登记机构
        ,iscreditadopted -- 征信规则校验结果
        ,zmauthflag -- 芝麻授权成功表示
        ,applyamount -- 审批额度(元)
        ,approvestatus -- 审批状态
        ,telenew -- 新联系方式
        ,resultmsg -- 审批结果描述
        ,autoscore -- 评分A卡评分
        ,execrate -- 执行年利率，借呗推送日利率X360
        ,expirydate -- 固化授信有效期
        ,lastadvicedate -- 终审通知时间
        ,certcodenew -- 新证件号码
        ,validdateendnew -- 新证件有效期到期日
        ,repaymode -- 还款方式
        ,isintercept -- 是否成功发起MQ
        ,creditno -- 授信编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_myjb_iqp_loan_app_op(
            serialno -- 流水号
        ,cusnamenew -- 新姓名
        ,certvalidenddate -- 证件有效期
        ,ischeckrule -- 反欺诈是否已校验标识
        ,lpr -- LPR
        ,ratefloatmode -- 利率浮动方式
        ,certtypenew -- 新证件类型
        ,requestid -- 请求流水号
        ,cusname -- 客户姓名
        ,rulingir -- 基准利率
        ,startdate -- 审批开始时间
        ,productcode -- 产品标识
        ,addressnew -- 新地址
        ,prdcode -- 产品编号
        ,prdname -- 产品名称
        ,certcode -- 证件号码
        ,sexnew -- 新性别
        ,professionnew -- 新职业
        ,riskrating -- 风险评级
        ,biztype -- 申请类型
        ,certtype -- 证件类型
        ,cardno -- 快捷卡卡号
        ,cusid -- 客户号
        ,isgetcuscode -- 是否开户成功
        ,floatratebp -- 利率浮动点差BP
        ,validdatestartnew -- 新证件有效期起始日
        ,applyno -- 授信申请单号
        ,isapplyscore -- 发送评分接口成功与否
        ,sysid -- 处理业务系统ID
        ,promotereason -- 调额的原因说明
        ,migtflag -- 迁移标志：crsrcrilcupl
        ,nationalitynew -- 新国籍
        ,source -- 申请来源
        ,bizmode -- 业务模式
        ,changeresultreason -- 额度、定价变更原因
        ,inputid -- 登记人
        ,isagree -- 借呗是否同意审批结果
        ,creditflag -- 当前用户授信标识
        ,failreason -- 备注信息
        ,resultcode -- 审批结果码
        ,iscollectcredit -- 个人征信采集成功与否
        ,ratetype -- 利率类型1基准2lpr
        ,mobileno -- 手机号
        ,modeltype -- 所属模块
        ,enddate -- 审批结束时间
        ,promotetype -- 调额的类型
        ,hasjbadmit -- 是否之前就有借呗额度
        ,solvencyratings -- 偿债能力评级
        ,applydate -- 申请日期
        ,expired -- 申请过期时间
        ,informflag -- 通知借呗成功与否
        ,inputbrid -- 登记机构
        ,iscreditadopted -- 征信规则校验结果
        ,zmauthflag -- 芝麻授权成功表示
        ,applyamount -- 审批额度(元)
        ,approvestatus -- 审批状态
        ,telenew -- 新联系方式
        ,resultmsg -- 审批结果描述
        ,autoscore -- 评分A卡评分
        ,execrate -- 执行年利率，借呗推送日利率X360
        ,expirydate -- 固化授信有效期
        ,lastadvicedate -- 终审通知时间
        ,certcodenew -- 新证件号码
        ,validdateendnew -- 新证件有效期到期日
        ,repaymode -- 还款方式
        ,isintercept -- 是否成功发起MQ
        ,creditno -- 授信编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.cusnamenew -- 新姓名
    ,o.certvalidenddate -- 证件有效期
    ,o.ischeckrule -- 反欺诈是否已校验标识
    ,o.lpr -- LPR
    ,o.ratefloatmode -- 利率浮动方式
    ,o.certtypenew -- 新证件类型
    ,o.requestid -- 请求流水号
    ,o.cusname -- 客户姓名
    ,o.rulingir -- 基准利率
    ,o.startdate -- 审批开始时间
    ,o.productcode -- 产品标识
    ,o.addressnew -- 新地址
    ,o.prdcode -- 产品编号
    ,o.prdname -- 产品名称
    ,o.certcode -- 证件号码
    ,o.sexnew -- 新性别
    ,o.professionnew -- 新职业
    ,o.riskrating -- 风险评级
    ,o.biztype -- 申请类型
    ,o.certtype -- 证件类型
    ,o.cardno -- 快捷卡卡号
    ,o.cusid -- 客户号
    ,o.isgetcuscode -- 是否开户成功
    ,o.floatratebp -- 利率浮动点差BP
    ,o.validdatestartnew -- 新证件有效期起始日
    ,o.applyno -- 授信申请单号
    ,o.isapplyscore -- 发送评分接口成功与否
    ,o.sysid -- 处理业务系统ID
    ,o.promotereason -- 调额的原因说明
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.nationalitynew -- 新国籍
    ,o.source -- 申请来源
    ,o.bizmode -- 业务模式
    ,o.changeresultreason -- 额度、定价变更原因
    ,o.inputid -- 登记人
    ,o.isagree -- 借呗是否同意审批结果
    ,o.creditflag -- 当前用户授信标识
    ,o.failreason -- 备注信息
    ,o.resultcode -- 审批结果码
    ,o.iscollectcredit -- 个人征信采集成功与否
    ,o.ratetype -- 利率类型1基准2lpr
    ,o.mobileno -- 手机号
    ,o.modeltype -- 所属模块
    ,o.enddate -- 审批结束时间
    ,o.promotetype -- 调额的类型
    ,o.hasjbadmit -- 是否之前就有借呗额度
    ,o.solvencyratings -- 偿债能力评级
    ,o.applydate -- 申请日期
    ,o.expired -- 申请过期时间
    ,o.informflag -- 通知借呗成功与否
    ,o.inputbrid -- 登记机构
    ,o.iscreditadopted -- 征信规则校验结果
    ,o.zmauthflag -- 芝麻授权成功表示
    ,o.applyamount -- 审批额度(元)
    ,o.approvestatus -- 审批状态
    ,o.telenew -- 新联系方式
    ,o.resultmsg -- 审批结果描述
    ,o.autoscore -- 评分A卡评分
    ,o.execrate -- 执行年利率，借呗推送日利率X360
    ,o.expirydate -- 固化授信有效期
    ,o.lastadvicedate -- 终审通知时间
    ,o.certcodenew -- 新证件号码
    ,o.validdateendnew -- 新证件有效期到期日
    ,o.repaymode -- 还款方式
    ,o.isintercept -- 是否成功发起MQ
    ,o.creditno -- 授信编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_myjb_iqp_loan_app_bk o
    left join ${iol_schema}.icms_myjb_iqp_loan_app_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_myjb_iqp_loan_app;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_myjb_iqp_loan_app') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_myjb_iqp_loan_app drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_myjb_iqp_loan_app add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_myjb_iqp_loan_app exchange partition p_${batch_date} with table ${iol_schema}.icms_myjb_iqp_loan_app_cl;
alter table ${iol_schema}.icms_myjb_iqp_loan_app exchange partition p_20991231 with table ${iol_schema}.icms_myjb_iqp_loan_app_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_myjb_iqp_loan_app to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myjb_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_myjb_iqp_loan_app_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_myjb_iqp_loan_app_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_myjb_iqp_loan_app',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
