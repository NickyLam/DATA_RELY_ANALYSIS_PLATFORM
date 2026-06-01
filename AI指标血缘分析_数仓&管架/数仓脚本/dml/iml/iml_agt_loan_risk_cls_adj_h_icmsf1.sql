/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_risk_cls_adj_h_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_loan_risk_cls_adj_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_risk_cls_adj_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,risk_cls_id -- 风险分类编号
    ,init_cls_id -- 原分类编号
    ,obj_id -- 对象编号
    ,obj_type_name -- 对象类型名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,cls_pd -- 分类期次
    ,adj_way_cd -- 调整方式代码
    ,curr_cls_way_cd -- 当前分类方式代码
    ,curr_cls_rest_cd -- 当前分类结果代码
    ,cls_adj_rs_descb -- 分类调整原因描述
    ,adj_cls_rest_cd -- 调整分类结果代码
    ,adj_appl_teller_id -- 调整申请柜员编号
    ,adj_appl_org_id -- 调整申请机构编号
    ,adj_appl_dt -- 调整申请日期
    ,apv_status_cd -- 审批状态代码
    ,belong_strip_line_cd -- 所属条线代码
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,move_flg -- 迁移标志
    ,idtfy_cmplt_dt -- 认定完成日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_risk_cls_adj_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_risk_cls_adj_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_risk_cls_adj_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_classify_adjust-1
insert into ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,risk_cls_id -- 风险分类编号
    ,init_cls_id -- 原分类编号
    ,obj_id -- 对象编号
    ,obj_type_name -- 对象类型名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,cls_pd -- 分类期次
    ,adj_way_cd -- 调整方式代码
    ,curr_cls_way_cd -- 当前分类方式代码
    ,curr_cls_rest_cd -- 当前分类结果代码
    ,cls_adj_rs_descb -- 分类调整原因描述
    ,adj_cls_rest_cd -- 调整分类结果代码
    ,adj_appl_teller_id -- 调整申请柜员编号
    ,adj_appl_org_id -- 调整申请机构编号
    ,adj_appl_dt -- 调整申请日期
    ,apv_status_cd -- 审批状态代码
    ,belong_strip_line_cd -- 所属条线代码
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,move_flg -- 迁移标志
    ,idtfy_cmplt_dt -- 认定完成日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300026'||P1.OBJECTNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 风险分类编号
    ,P1.RELATIVESERIALNO -- 原分类编号
    ,P1.OBJECTNO -- 对象编号
    ,P1.OBJECTTYPE -- 对象类型名称
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,P1.PRODUCTID -- 产品编号
    ,nvl(trim(P1.ACCOUNTMONTH),0) -- 分类期次
    ,nvl(TRIM(P1.ADJUSTTYPE),'-') -- 调整方式代码
    ,nvl(TRIM(P1.CURRCLASSIFYTYPE),'-') -- 当前分类方式代码
    ,nvl(TRIM(P1.CURRCLASSIFYRESULT),'-') -- 当前分类结果代码
    ,P1.ADJUSTREASON -- 分类调整原因描述
    ,nvl(TRIM(P1.ADJUSTCLASSIFYRESULT),'-') -- 调整分类结果代码
    ,P1.ADJUSTAPPLYER -- 调整申请柜员编号
    ,P1.ADJUSTORGID -- 调整申请机构编号
    ,P1.ADJUSTDATE -- 调整申请日期
    ,nvl(TRIM(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,nvl(TRIM(P1.BELONGDEPT),'-') -- 所属条线代码
    ,P1.OPERATEUSERID -- 业务经办人编号
    ,P1.OPERATEORGID -- 经办机构编号
    ,P1.OPERATEDATE -- 经办日期
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 变更日期
    ,CASE WHEN TRIM(P1.MIGTFLAG) IS NOT NULL THEN '1' ELSE '0' END -- 迁移标志
    ,P1.ADJUSTFINISHDATE -- 认定完成日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_classify_adjust' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_classify_adjust p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,risk_cls_id
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,risk_cls_id -- 风险分类编号
    ,init_cls_id -- 原分类编号
    ,obj_id -- 对象编号
    ,obj_type_name -- 对象类型名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,cls_pd -- 分类期次
    ,adj_way_cd -- 调整方式代码
    ,curr_cls_way_cd -- 当前分类方式代码
    ,curr_cls_rest_cd -- 当前分类结果代码
    ,cls_adj_rs_descb -- 分类调整原因描述
    ,adj_cls_rest_cd -- 调整分类结果代码
    ,adj_appl_teller_id -- 调整申请柜员编号
    ,adj_appl_org_id -- 调整申请机构编号
    ,adj_appl_dt -- 调整申请日期
    ,apv_status_cd -- 审批状态代码
    ,belong_strip_line_cd -- 所属条线代码
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,move_flg -- 迁移标志
    ,idtfy_cmplt_dt -- 认定完成日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,risk_cls_id -- 风险分类编号
    ,init_cls_id -- 原分类编号
    ,obj_id -- 对象编号
    ,obj_type_name -- 对象类型名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,cls_pd -- 分类期次
    ,adj_way_cd -- 调整方式代码
    ,curr_cls_way_cd -- 当前分类方式代码
    ,curr_cls_rest_cd -- 当前分类结果代码
    ,cls_adj_rs_descb -- 分类调整原因描述
    ,adj_cls_rest_cd -- 调整分类结果代码
    ,adj_appl_teller_id -- 调整申请柜员编号
    ,adj_appl_org_id -- 调整申请机构编号
    ,adj_appl_dt -- 调整申请日期
    ,apv_status_cd -- 审批状态代码
    ,belong_strip_line_cd -- 所属条线代码
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,move_flg -- 迁移标志
    ,idtfy_cmplt_dt -- 认定完成日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.risk_cls_id, o.risk_cls_id) as risk_cls_id -- 风险分类编号
    ,nvl(n.init_cls_id, o.init_cls_id) as init_cls_id -- 原分类编号
    ,nvl(n.obj_id, o.obj_id) as obj_id -- 对象编号
    ,nvl(n.obj_type_name, o.obj_type_name) as obj_type_name -- 对象类型名称
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.cls_pd, o.cls_pd) as cls_pd -- 分类期次
    ,nvl(n.adj_way_cd, o.adj_way_cd) as adj_way_cd -- 调整方式代码
    ,nvl(n.curr_cls_way_cd, o.curr_cls_way_cd) as curr_cls_way_cd -- 当前分类方式代码
    ,nvl(n.curr_cls_rest_cd, o.curr_cls_rest_cd) as curr_cls_rest_cd -- 当前分类结果代码
    ,nvl(n.cls_adj_rs_descb, o.cls_adj_rs_descb) as cls_adj_rs_descb -- 分类调整原因描述
    ,nvl(n.adj_cls_rest_cd, o.adj_cls_rest_cd) as adj_cls_rest_cd -- 调整分类结果代码
    ,nvl(n.adj_appl_teller_id, o.adj_appl_teller_id) as adj_appl_teller_id -- 调整申请柜员编号
    ,nvl(n.adj_appl_org_id, o.adj_appl_org_id) as adj_appl_org_id -- 调整申请机构编号
    ,nvl(n.adj_appl_dt, o.adj_appl_dt) as adj_appl_dt -- 调整申请日期
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.belong_strip_line_cd, o.belong_strip_line_cd) as belong_strip_line_cd -- 所属条线代码
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 经办柜员编号
    ,nvl(n.oper_org_id, o.oper_org_id) as oper_org_id -- 经办机构编号
    ,nvl(n.oper_dt, o.oper_dt) as oper_dt -- 经办日期
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,nvl(n.move_flg, o.move_flg) as move_flg -- 迁移标志
    ,nvl(n.idtfy_cmplt_dt, o.idtfy_cmplt_dt) as idtfy_cmplt_dt -- 认定完成日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.risk_cls_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.risk_cls_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.risk_cls_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.risk_cls_id = n.risk_cls_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.risk_cls_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.risk_cls_id is null
    )
    or (
        o.init_cls_id <> n.init_cls_id
        or o.obj_id <> n.obj_id
        or o.obj_type_name <> n.obj_type_name
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.prod_id <> n.prod_id
        or o.cls_pd <> n.cls_pd
        or o.adj_way_cd <> n.adj_way_cd
        or o.curr_cls_way_cd <> n.curr_cls_way_cd
        or o.curr_cls_rest_cd <> n.curr_cls_rest_cd
        or o.cls_adj_rs_descb <> n.cls_adj_rs_descb
        or o.adj_cls_rest_cd <> n.adj_cls_rest_cd
        or o.adj_appl_teller_id <> n.adj_appl_teller_id
        or o.adj_appl_org_id <> n.adj_appl_org_id
        or o.adj_appl_dt <> n.adj_appl_dt
        or o.apv_status_cd <> n.apv_status_cd
        or o.belong_strip_line_cd <> n.belong_strip_line_cd
        or o.oper_teller_id <> n.oper_teller_id
        or o.oper_org_id <> n.oper_org_id
        or o.oper_dt <> n.oper_dt
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.modif_dt <> n.modif_dt
        or o.move_flg <> n.move_flg
        or o.idtfy_cmplt_dt <> n.idtfy_cmplt_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,risk_cls_id -- 风险分类编号
    ,init_cls_id -- 原分类编号
    ,obj_id -- 对象编号
    ,obj_type_name -- 对象类型名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,cls_pd -- 分类期次
    ,adj_way_cd -- 调整方式代码
    ,curr_cls_way_cd -- 当前分类方式代码
    ,curr_cls_rest_cd -- 当前分类结果代码
    ,cls_adj_rs_descb -- 分类调整原因描述
    ,adj_cls_rest_cd -- 调整分类结果代码
    ,adj_appl_teller_id -- 调整申请柜员编号
    ,adj_appl_org_id -- 调整申请机构编号
    ,adj_appl_dt -- 调整申请日期
    ,apv_status_cd -- 审批状态代码
    ,belong_strip_line_cd -- 所属条线代码
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,move_flg -- 迁移标志
    ,idtfy_cmplt_dt -- 认定完成日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,risk_cls_id -- 风险分类编号
    ,init_cls_id -- 原分类编号
    ,obj_id -- 对象编号
    ,obj_type_name -- 对象类型名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,cls_pd -- 分类期次
    ,adj_way_cd -- 调整方式代码
    ,curr_cls_way_cd -- 当前分类方式代码
    ,curr_cls_rest_cd -- 当前分类结果代码
    ,cls_adj_rs_descb -- 分类调整原因描述
    ,adj_cls_rest_cd -- 调整分类结果代码
    ,adj_appl_teller_id -- 调整申请柜员编号
    ,adj_appl_org_id -- 调整申请机构编号
    ,adj_appl_dt -- 调整申请日期
    ,apv_status_cd -- 审批状态代码
    ,belong_strip_line_cd -- 所属条线代码
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,move_flg -- 迁移标志
    ,idtfy_cmplt_dt -- 认定完成日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.risk_cls_id -- 风险分类编号
    ,o.init_cls_id -- 原分类编号
    ,o.obj_id -- 对象编号
    ,o.obj_type_name -- 对象类型名称
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.prod_id -- 产品编号
    ,o.cls_pd -- 分类期次
    ,o.adj_way_cd -- 调整方式代码
    ,o.curr_cls_way_cd -- 当前分类方式代码
    ,o.curr_cls_rest_cd -- 当前分类结果代码
    ,o.cls_adj_rs_descb -- 分类调整原因描述
    ,o.adj_cls_rest_cd -- 调整分类结果代码
    ,o.adj_appl_teller_id -- 调整申请柜员编号
    ,o.adj_appl_org_id -- 调整申请机构编号
    ,o.adj_appl_dt -- 调整申请日期
    ,o.apv_status_cd -- 审批状态代码
    ,o.belong_strip_line_cd -- 所属条线代码
    ,o.oper_teller_id -- 经办柜员编号
    ,o.oper_org_id -- 经办机构编号
    ,o.oper_dt -- 经办日期
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.modif_dt -- 变更日期
    ,o.move_flg -- 迁移标志
    ,o.idtfy_cmplt_dt -- 认定完成日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.risk_cls_id = n.risk_cls_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.risk_cls_id = d.risk_cls_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_risk_cls_adj_h;
--alter table ${iml_schema}.agt_loan_risk_cls_adj_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_risk_cls_adj_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_risk_cls_adj_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_loan_risk_cls_adj_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_risk_cls_adj_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_risk_cls_adj_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_risk_cls_adj_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_risk_cls_adj_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_risk_cls_adj_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
