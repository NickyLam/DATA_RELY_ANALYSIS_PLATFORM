/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_myloan_crdt_appl_mybkf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_myloan_crdt_appl_mybkf1_tm purge;
drop table ${iml_schema}.agt_myloan_crdt_appl_mybkf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_myloan_crdt_appl add partition p_mybkf1 values ('mybkf1')(
        subpartition p_mybkf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_myloan_crdt_appl modify partition p_mybkf1
    add subpartition p_mybkf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_myloan_crdt_appl_mybkf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_myloan_crdt_appl partition for ('mybkf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_myloan_crdt_appl_mybkf1_tm
compress ${option_switch} for query high
as
select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_id -- 授信申请编号
    ,appl_flow_num -- 申请流水号
    ,prod_id -- 产品编号
    ,appl_dt -- 申请日期
    ,cust_name -- 客户名称
    ,cust_id -- 客户编号
    ,crdt_lmt -- 授信额度
    ,apv_start_tm -- 审批开始时间
    ,apv_end_tm -- 审批结束时间
    ,apv_status_cd -- 审批状态代码
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,final_jud_advise_tm -- 终审通知时间
    ,cust_mgr_id -- 客户经理编号
    ,rgst_org_id -- 登记机构编号
    ,farm_flg -- 农户标志
    ,refuse_rs -- 拒绝原因
    ,mobile_no -- 手机号码
    ,crdt_sugst_lmt -- 授信建议额度
    ,netw_vrfction_status_cd -- 联网核查状态代码
    ,pbc_custs_mang_lab -- 人行客群经营标签
    ,bank_supv_custs_mang_lab -- 银监客群经营标签
    ,prod_name -- 产品名称
    ,apv_rest_cd -- 审批结果代码
    ,bus_scene_cd -- 业务场景代码
    ,lmt_status_cd -- 额度状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_myloan_crdt_appl
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_myloan_crdt_appl_mybkf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_myloan_crdt_appl partition for ('mybkf1') where 0=1;

-- 2.1 insert data to tm table
-- icms_mybk_iqp_loan_app-
insert into ${iml_schema}.agt_myloan_crdt_appl_mybkf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_id -- 授信申请编号
    ,appl_flow_num -- 申请流水号
    ,prod_id -- 产品编号
    ,appl_dt -- 申请日期
    ,cust_name -- 客户名称
    ,cust_id -- 客户编号
    ,crdt_lmt -- 授信额度
    ,apv_start_tm -- 审批开始时间
    ,apv_end_tm -- 审批结束时间
    ,apv_status_cd -- 审批状态代码
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,final_jud_advise_tm -- 终审通知时间
    ,cust_mgr_id -- 客户经理编号
    ,rgst_org_id -- 登记机构编号
    ,farm_flg -- 农户标志
    ,refuse_rs -- 拒绝原因
    ,mobile_no -- 手机号码
    ,crdt_sugst_lmt -- 授信建议额度
    ,netw_vrfction_status_cd -- 联网核查状态代码
    ,pbc_custs_mang_lab -- 人行客群经营标签
    ,bank_supv_custs_mang_lab -- 银监客群经营标签
    ,prod_name -- 产品名称
    ,apv_rest_cd -- 审批结果代码
    ,bus_scene_cd -- 业务场景代码
    ,lmt_status_cd -- 额度状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '203006'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 授信申请编号
    ,P1.APPLYNO -- 申请流水号
    ,P1.PRDCODE -- 产品编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.APPLYDATE) -- 申请日期
    ,P1.CUSNAME -- 客户名称
    ,P1.CUSID -- 客户编号
    ,P1.APPLYAMOUNT -- 授信额度
    ,to_timestamp (nvl(trim(P1.STARTDATE),'19000101'),'yyyy-mm-dd hh24:mi:ss') -- 审批开始时间
    ,to_timestamp (nvl(trim(P1.ENDDATE),'20991231'),'yyyy-mm-dd hh24:mi:ss') -- 审批结束时间
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,DECODE(P1.INFORMFINALFLAG,' ','-','2','0',P1.INFORMFINALFLAG) -- 终审通知成功标志
    ,to_timestamp(trim(P1.LASTADVICEDATE),'yyyy-mm-dd hh24:mi:ss') -- 终审通知时间
    ,P1.INPUTID -- 客户经理编号
    ,P1.INPUTBRID -- 登记机构编号
    ,nvl(trim(P1.FARMERFLAG),'-') -- 农户标志
    ,P1.ACKMSG -- 拒绝原因
    ,P1.MOBILE -- 手机号码
    ,P1.PLATFORMADMIT -- 授信建议额度
    ,' ' -- 联网核查状态代码
    ,P1.TARGETJYFLAG2 -- 人行客群经营标签
    ,P1.TARGETJYFLAG3 -- 银监客群经营标签
    ,P1.PRDNAME -- 产品名称
    ,NVL(trim(P1.PLATFORMACCESS),'-') -- 审批结果代码
    ,P1.LOANAR -- 业务场景代码
    ,NVL(trim(P1.BALSTATUS),'-') -- 额度状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_mybk_iqp_loan_app' -- 源表名称
    ,'mybkf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_mybk_iqp_loan_app p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
  and P1.PRDCODE <> '201020100057'
;
commit;

-- icms_mybkzq_iqp_loan_app-1
insert into ${iml_schema}.agt_myloan_crdt_appl_mybkf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_id -- 授信申请编号
    ,appl_flow_num -- 申请流水号
    ,prod_id -- 产品编号
    ,appl_dt -- 申请日期
    ,cust_name -- 客户名称
    ,cust_id -- 客户编号
    ,crdt_lmt -- 授信额度
    ,apv_start_tm -- 审批开始时间
    ,apv_end_tm -- 审批结束时间
    ,apv_status_cd -- 审批状态代码
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,final_jud_advise_tm -- 终审通知时间
    ,cust_mgr_id -- 客户经理编号
    ,rgst_org_id -- 登记机构编号
    ,farm_flg -- 农户标志
    ,refuse_rs -- 拒绝原因
    ,mobile_no -- 手机号码
    ,crdt_sugst_lmt -- 授信建议额度
    ,netw_vrfction_status_cd -- 联网核查状态代码
    ,pbc_custs_mang_lab -- 人行客群经营标签
    ,bank_supv_custs_mang_lab -- 银监客群经营标签
    ,prod_name -- 产品名称
    ,apv_rest_cd -- 审批结果代码
    ,bus_scene_cd -- 业务场景代码
    ,lmt_status_cd -- 额度状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '203006'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 授信申请编号
    ,P1.APPLYNO -- 申请流水号
    ,P1.PRDCODE -- 产品编号
    ,P1.APPLYDATE -- 申请日期
    ,P1.CUSNAME -- 客户名称
    ,P1.CUSID -- 客户编号
    ,P1.APPLYAMOUNT -- 授信额度
    ,to_timestamp ('19000101','yyyy-mm-dd hh24:mi:ss') -- 审批开始时间
    ,to_timestamp ('20991231','yyyy-mm-dd hh24:mi:ss') -- 审批结束时间
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,DECODE(P1.INFORMZSFLAG,' ','-','2','0',P1.INFORMZSFLAG) -- 终审通知成功标志
    ,to_timestamp ('20991231','yyyy-mm-dd hh24:mi:ss') -- 终审通知时间
    ,P1.INPUTID -- 客户经理编号
    ,P1.INPUTORGID -- 登记机构编号
    ,'-' -- 农户标志
    ,' ' -- 拒绝原因
    ,' ' -- 手机号码
    ,0.00 -- 授信建议额度
    ,' ' -- 联网核查状态代码
    ,' ' -- 人行客群经营标签
    ,' ' -- 银监客群经营标签
    ,P1.PRDNAME -- 产品名称
    ,nvl(trim(P1.PLATFORMACCESS),'-')   -- 审批结果代码
    ,' ' -- 业务场景代码
    ,'-' -- 额度状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_mybkzq_iqp_loan_app' -- 源表名称
    ,'mybkf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_mybkzq_iqp_loan_app p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd') 
;
commit;

insert into ${iml_schema}.agt_myloan_crdt_appl_mybkf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_id -- 授信申请编号
    ,appl_flow_num -- 申请流水号
    ,prod_id -- 产品编号
    ,appl_dt -- 申请日期
    ,cust_name -- 客户名称
    ,cust_id -- 客户编号
    ,crdt_lmt -- 授信额度
    ,apv_start_tm -- 审批开始时间
    ,apv_end_tm -- 审批结束时间
    ,apv_status_cd -- 审批状态代码
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,final_jud_advise_tm -- 终审通知时间
    ,cust_mgr_id -- 客户经理编号
    ,rgst_org_id -- 登记机构编号
    ,farm_flg -- 农户标志
    ,refuse_rs -- 拒绝原因
    ,mobile_no -- 手机号码
    ,crdt_sugst_lmt -- 授信建议额度
    ,netw_vrfction_status_cd -- 联网核查状态代码
    ,pbc_custs_mang_lab -- 人行客群经营标签
    ,bank_supv_custs_mang_lab -- 银监客群经营标签
    ,prod_name -- 产品名称
    ,apv_rest_cd -- 审批结果代码
    ,bus_scene_cd -- 业务场景代码
    ,lmt_status_cd -- 额度状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206001'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 授信申请编号
    ,P1.APPLYNO -- 申请流水号
    ,P1.PRDCODE -- 产品编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.APPLYDATE) -- 申请日期
    ,P1.CUSNAME -- 客户名称
    ,P1.CUSID -- 客户编号
    ,P1.APPLYAMOUNT -- 授信额度
    ,to_timestamp (nvl(trim(P1.STARTDATE),'19000101'),'yyyy-mm-dd hh24:mi:ss') -- 审批开始时间
    ,to_timestamp (nvl(trim(P1.ENDDATE),'20991231'),'yyyy-mm-dd hh24:mi:ss') -- 审批结束时间
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,nvl(trim(P1.INFORMFINALFLAG),'-') -- 终审通知成功标志
    ,to_timestamp(trim(P1.LASTADVICEDATE),'yyyy-mm-dd hh24:mi:ss') -- 终审通知时间
    ,P1.INPUTID -- 客户经理编号
    ,P1.INPUTBRID -- 登记机构编号
    ,nvl(trim(P1.FARMERFLAG),'-') -- 农户标志
    ,P1.ACKMSG -- 拒绝原因
    ,P1.MOBILE -- 手机号码
    ,P1.PLATFORMADMIT -- 授信建议额度
    ,' ' -- 联网核查状态代码
    ,P1.TARGETJYFLAG2 -- 人行客群经营标签
    ,P1.TARGETJYFLAG3 -- 银监客群经营标签
    ,P1.PRDNAME -- 产品名称
    ,NVL(trim(P1.PLATFORMACCESS),'-') -- 审批结果代码
    ,P1.LOANAR -- 业务场景代码
    ,NVL(trim(P1.BALSTATUS),'-') -- 额度状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_mybkzd_iqp_loan_app' -- 源表名称
    ,'mybkf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_mybkzd_iqp_loan_app p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_myloan_crdt_appl_mybkf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_myloan_crdt_appl_mybkf1_ex(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_id -- 授信申请编号
    ,appl_flow_num -- 申请流水号
    ,prod_id -- 产品编号
    ,appl_dt -- 申请日期
    ,cust_name -- 客户名称
    ,cust_id -- 客户编号
    ,crdt_lmt -- 授信额度
    ,apv_start_tm -- 审批开始时间
    ,apv_end_tm -- 审批结束时间
    ,apv_status_cd -- 审批状态代码
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,final_jud_advise_tm -- 终审通知时间
    ,cust_mgr_id -- 客户经理编号
    ,rgst_org_id -- 登记机构编号
    ,farm_flg -- 农户标志
    ,refuse_rs -- 拒绝原因
    ,mobile_no -- 手机号码
    ,crdt_sugst_lmt -- 授信建议额度
    ,netw_vrfction_status_cd -- 联网核查状态代码
    ,pbc_custs_mang_lab -- 人行客群经营标签
    ,bank_supv_custs_mang_lab -- 银监客群经营标签
    ,prod_name -- 产品名称
    ,apv_rest_cd -- 审批结果代码
    ,bus_scene_cd -- 业务场景代码
    ,lmt_status_cd -- 额度状态代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.crdt_appl_id, o.crdt_appl_id) as crdt_appl_id -- 授信申请编号
    ,nvl(n.appl_flow_num, o.appl_flow_num) as appl_flow_num -- 申请流水号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.appl_dt, o.appl_dt) as appl_dt -- 申请日期
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.crdt_lmt, o.crdt_lmt) as crdt_lmt -- 授信额度
    ,nvl(n.apv_start_tm, o.apv_start_tm) as apv_start_tm -- 审批开始时间
    ,nvl(n.apv_end_tm, o.apv_end_tm) as apv_end_tm -- 审批结束时间
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.final_jud_advise_sucs_flg, o.final_jud_advise_sucs_flg) as final_jud_advise_sucs_flg -- 终审通知成功标志
    ,nvl(n.final_jud_advise_tm, o.final_jud_advise_tm) as final_jud_advise_tm -- 终审通知时间
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.farm_flg, o.farm_flg) as farm_flg -- 农户标志
    ,nvl(n.refuse_rs, o.refuse_rs) as refuse_rs -- 拒绝原因
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.crdt_sugst_lmt, o.crdt_sugst_lmt) as crdt_sugst_lmt -- 授信建议额度
    ,nvl(n.netw_vrfction_status_cd, o.netw_vrfction_status_cd) as netw_vrfction_status_cd -- 联网核查状态代码
    ,nvl(n.pbc_custs_mang_lab, o.pbc_custs_mang_lab) as pbc_custs_mang_lab -- 人行客群经营标签
    ,nvl(n.bank_supv_custs_mang_lab, o.bank_supv_custs_mang_lab) as bank_supv_custs_mang_lab -- 银监客群经营标签
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.apv_rest_cd, o.apv_rest_cd) as apv_rest_cd -- 审批结果代码
    ,nvl(n.bus_scene_cd, o.bus_scene_cd) as bus_scene_cd -- 业务场景代码
    ,nvl(n.lmt_status_cd, o.lmt_status_cd) as lmt_status_cd -- 额度状态代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.appl_id is null
                and o.lp_id is null
            ) or (
                o.crdt_appl_id <> n.crdt_appl_id
                or o.appl_flow_num <> n.appl_flow_num
                or o.prod_id <> n.prod_id
                or o.appl_dt <> n.appl_dt
                or o.cust_name <> n.cust_name
                or o.cust_id <> n.cust_id
                or o.crdt_lmt <> n.crdt_lmt
                or o.apv_start_tm <> n.apv_start_tm
                or o.apv_end_tm <> n.apv_end_tm
                or o.apv_status_cd <> n.apv_status_cd
                or o.final_jud_advise_sucs_flg <> n.final_jud_advise_sucs_flg
                or o.final_jud_advise_tm <> n.final_jud_advise_tm
                or o.cust_mgr_id <> n.cust_mgr_id
                or o.rgst_org_id <> n.rgst_org_id
                or o.farm_flg <> n.farm_flg
                or o.refuse_rs <> n.refuse_rs
                or o.mobile_no <> n.mobile_no
                or o.crdt_sugst_lmt <> n.crdt_sugst_lmt
                or o.netw_vrfction_status_cd <> n.netw_vrfction_status_cd
                or o.pbc_custs_mang_lab <> n.pbc_custs_mang_lab
                or o.bank_supv_custs_mang_lab <> n.bank_supv_custs_mang_lab
                or o.prod_name <> n.prod_name
                or o.apv_rest_cd <> n.apv_rest_cd
                or o.bus_scene_cd <> n.bus_scene_cd
                or o.lmt_status_cd <> n.lmt_status_cd
            ) or (
                 case when (
                           n.appl_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.appl_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_myloan_crdt_appl_mybkf1_tm n
    full join ${iml_schema}.agt_myloan_crdt_appl_mybkf1_bk o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_myloan_crdt_appl truncate partition for ('mybkf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_myloan_crdt_appl exchange subpartition p_mybkf1_${batch_date} with table ${iml_schema}.agt_myloan_crdt_appl_mybkf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_myloan_crdt_appl drop subpartition p_mybkf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_myloan_crdt_appl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_myloan_crdt_appl_mybkf1_tm purge;
drop table ${iml_schema}.agt_myloan_crdt_appl_mybkf1_ex purge;
drop table ${iml_schema}.agt_myloan_crdt_appl_mybkf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_myloan_crdt_appl', partname => 'p_mybkf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);