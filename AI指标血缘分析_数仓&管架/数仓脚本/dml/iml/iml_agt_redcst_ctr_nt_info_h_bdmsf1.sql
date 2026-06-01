/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_redcst_ctr_nt_info_h_bdmsf1
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
alter table ${iml_schema}.agt_redcst_ctr_nt_info_h add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_redcst_ctr_nt_info_h partition for ('bdmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ctr_nt_ser_num -- 成交单序列号
    ,ctr_nt_id -- 成交单编号
    ,bus_type_cd -- 业务类型代码
    ,quot_bill_id -- 报价单编号
    ,redcst_batch_id -- 再贴现批次编号
    ,bag_way_cd -- 成交方式代码
    ,tra_dt -- 成交日期
    ,bag_tm -- 成交时间
    ,bag_status_cd -- 成交状态代码
    ,clear_status_cd -- 清算状态代码
    ,exp_stl_status_cd -- 到期结算状态代码
    ,apv_rest_cd -- 审批结果代码
    ,org_cd -- 机构代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,pbc_org_cd -- 人行机构代码
    ,quot_bill_status_cd -- 报价单状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_redcst_ctr_nt_info_h partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_redcst_ctr_nt_info_h partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_redcst_ctr_nt_info_h partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_ces_redsct_deal-
insert into ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ctr_nt_ser_num -- 成交单序列号
    ,ctr_nt_id -- 成交单编号
    ,bus_type_cd -- 业务类型代码
    ,quot_bill_id -- 报价单编号
    ,redcst_batch_id -- 再贴现批次编号
    ,bag_way_cd -- 成交方式代码
    ,tra_dt -- 成交日期
    ,bag_tm -- 成交时间
    ,bag_status_cd -- 成交状态代码
    ,clear_status_cd -- 清算状态代码
    ,exp_stl_status_cd -- 到期结算状态代码
    ,apv_rest_cd -- 审批结果代码
    ,org_cd -- 机构代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,pbc_org_cd -- 人行机构代码
    ,quot_bill_status_cd -- 报价单状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223104'||P1.ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ID -- 成交单序列号
    ,P1.DEALED_NO -- 成交单编号
    ,nvl(trim(P1.BUSI_TYPE),'RBT00') -- 业务类型代码
    ,P1.QUOTE_NO -- 报价单编号
    ,P1.BUSS_CONTRACT_ID -- 再贴现批次编号
    ,nvl(trim(P1.TRADE_TYPE),'-'） -- 成交方式代码
    ,${iml_schema}.DATEFORMAT_MAX2(P1.TRADE_DATE) -- 成交日期
    ,${iml_schema}.TIMEFORMAT_MAX2(P1.TRADE_TIME) -- 成交时间
    ,nvl(trim(P1.TRADE_STATUS),'') -- 成交状态代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.SETTLE_STATUS END -- 清算状态代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DUE_SETTLE_STATUS END -- 到期结算状态代码
    ,nvl(trim(P1.APPROVE_RESULT),'-'） -- 审批结果代码
    ,P1.BRH_NO -- 机构代码
    ,P1.PRODUCT_NO -- 产品编号
    ,nvl(trim(p2.PROD_CODE),' ') -- 标准产品编号
    ,P1.PBC_BRH_NO -- 人行机构代码
    ,nvl(trim(P1.QUOTE_STATUS),'-'） -- 报价单状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_ces_redsct_deal' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_ces_redsct_deal p1
    left join ${iol_schema}.bdms_meta_deposit_define p2 on p1.PRODUCT_NO=p2.PRODUCT_NO
and p2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') 
AND p2.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.SETTLE_STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_CES_REDSCT_DEAL'
        AND R1.SRC_FIELD_EN_NAME= 'SETTLE_STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_REDCST_CTR_NT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.SETTLE_STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_CES_REDSCT_DEAL'
        AND R2.SRC_FIELD_EN_NAME= 'DUE_SETTLE_STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_REDCST_CTR_NT_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'EXP_STL_STATUS_CD'
where  1 = 1 
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_tm 
  	                                group by 
  	                                        agt_id
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ctr_nt_ser_num -- 成交单序列号
    ,ctr_nt_id -- 成交单编号
    ,bus_type_cd -- 业务类型代码
    ,quot_bill_id -- 报价单编号
    ,redcst_batch_id -- 再贴现批次编号
    ,bag_way_cd -- 成交方式代码
    ,tra_dt -- 成交日期
    ,bag_tm -- 成交时间
    ,bag_status_cd -- 成交状态代码
    ,clear_status_cd -- 清算状态代码
    ,exp_stl_status_cd -- 到期结算状态代码
    ,apv_rest_cd -- 审批结果代码
    ,org_cd -- 机构代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,pbc_org_cd -- 人行机构代码
    ,quot_bill_status_cd -- 报价单状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ctr_nt_ser_num -- 成交单序列号
    ,ctr_nt_id -- 成交单编号
    ,bus_type_cd -- 业务类型代码
    ,quot_bill_id -- 报价单编号
    ,redcst_batch_id -- 再贴现批次编号
    ,bag_way_cd -- 成交方式代码
    ,tra_dt -- 成交日期
    ,bag_tm -- 成交时间
    ,bag_status_cd -- 成交状态代码
    ,clear_status_cd -- 清算状态代码
    ,exp_stl_status_cd -- 到期结算状态代码
    ,apv_rest_cd -- 审批结果代码
    ,org_cd -- 机构代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,pbc_org_cd -- 人行机构代码
    ,quot_bill_status_cd -- 报价单状态代码
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
    ,nvl(n.ctr_nt_ser_num, o.ctr_nt_ser_num) as ctr_nt_ser_num -- 成交单序列号
    ,nvl(n.ctr_nt_id, o.ctr_nt_id) as ctr_nt_id -- 成交单编号
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.quot_bill_id, o.quot_bill_id) as quot_bill_id -- 报价单编号
    ,nvl(n.redcst_batch_id, o.redcst_batch_id) as redcst_batch_id -- 再贴现批次编号
    ,nvl(n.bag_way_cd, o.bag_way_cd) as bag_way_cd -- 成交方式代码
    ,nvl(n.tra_dt, o.tra_dt) as tra_dt -- 成交日期
    ,nvl(n.bag_tm, o.bag_tm) as bag_tm -- 成交时间
    ,nvl(n.bag_status_cd, o.bag_status_cd) as bag_status_cd -- 成交状态代码
    ,nvl(n.clear_status_cd, o.clear_status_cd) as clear_status_cd -- 清算状态代码
    ,nvl(n.exp_stl_status_cd, o.exp_stl_status_cd) as exp_stl_status_cd -- 到期结算状态代码
    ,nvl(n.apv_rest_cd, o.apv_rest_cd) as apv_rest_cd -- 审批结果代码
    ,nvl(n.org_cd, o.org_cd) as org_cd -- 机构代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.pbc_org_cd, o.pbc_org_cd) as pbc_org_cd -- 人行机构代码
    ,nvl(n.quot_bill_status_cd, o.quot_bill_status_cd) as quot_bill_status_cd -- 报价单状态代码
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_tm n
    full join (select * from ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.ctr_nt_ser_num <> n.ctr_nt_ser_num
        or o.ctr_nt_id <> n.ctr_nt_id
        or o.bus_type_cd <> n.bus_type_cd
        or o.quot_bill_id <> n.quot_bill_id
        or o.redcst_batch_id <> n.redcst_batch_id
        or o.bag_way_cd <> n.bag_way_cd
        or o.tra_dt <> n.tra_dt
        or o.bag_tm <> n.bag_tm
        or o.bag_status_cd <> n.bag_status_cd
        or o.clear_status_cd <> n.clear_status_cd
        or o.exp_stl_status_cd <> n.exp_stl_status_cd
        or o.apv_rest_cd <> n.apv_rest_cd
        or o.org_cd <> n.org_cd
        or o.prod_id <> n.prod_id
        or o.std_prod_id <> n.std_prod_id
        or o.pbc_org_cd <> n.pbc_org_cd
        or o.quot_bill_status_cd <> n.quot_bill_status_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ctr_nt_ser_num -- 成交单序列号
    ,ctr_nt_id -- 成交单编号
    ,bus_type_cd -- 业务类型代码
    ,quot_bill_id -- 报价单编号
    ,redcst_batch_id -- 再贴现批次编号
    ,bag_way_cd -- 成交方式代码
    ,tra_dt -- 成交日期
    ,bag_tm -- 成交时间
    ,bag_status_cd -- 成交状态代码
    ,clear_status_cd -- 清算状态代码
    ,exp_stl_status_cd -- 到期结算状态代码
    ,apv_rest_cd -- 审批结果代码
    ,org_cd -- 机构代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,pbc_org_cd -- 人行机构代码
    ,quot_bill_status_cd -- 报价单状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ctr_nt_ser_num -- 成交单序列号
    ,ctr_nt_id -- 成交单编号
    ,bus_type_cd -- 业务类型代码
    ,quot_bill_id -- 报价单编号
    ,redcst_batch_id -- 再贴现批次编号
    ,bag_way_cd -- 成交方式代码
    ,tra_dt -- 成交日期
    ,bag_tm -- 成交时间
    ,bag_status_cd -- 成交状态代码
    ,clear_status_cd -- 清算状态代码
    ,exp_stl_status_cd -- 到期结算状态代码
    ,apv_rest_cd -- 审批结果代码
    ,org_cd -- 机构代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,pbc_org_cd -- 人行机构代码
    ,quot_bill_status_cd -- 报价单状态代码
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
    ,o.ctr_nt_ser_num -- 成交单序列号
    ,o.ctr_nt_id -- 成交单编号
    ,o.bus_type_cd -- 业务类型代码
    ,o.quot_bill_id -- 报价单编号
    ,o.redcst_batch_id -- 再贴现批次编号
    ,o.bag_way_cd -- 成交方式代码
    ,o.tra_dt -- 成交日期
    ,o.bag_tm -- 成交时间
    ,o.bag_status_cd -- 成交状态代码
    ,o.clear_status_cd -- 清算状态代码
    ,o.exp_stl_status_cd -- 到期结算状态代码
    ,o.apv_rest_cd -- 审批结果代码
    ,o.org_cd -- 机构代码
    ,o.prod_id -- 产品编号
    ,o.std_prod_id -- 标准产品编号
    ,o.pbc_org_cd -- 人行机构代码
    ,o.quot_bill_status_cd -- 报价单状态代码
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
from ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_bk o
    left join ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_redcst_ctr_nt_info_h;
--alter table ${iml_schema}.agt_redcst_ctr_nt_info_h truncate partition for ('bdmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_redcst_ctr_nt_info_h') 
               and substr(subpartition_name,1,8)=upper('p_bdmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_redcst_ctr_nt_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_redcst_ctr_nt_info_h modify partition p_bdmsf1 
add subpartition p_bdmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_redcst_ctr_nt_info_h exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_cl;
alter table ${iml_schema}.agt_redcst_ctr_nt_info_h exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_redcst_ctr_nt_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_redcst_ctr_nt_info_h_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_redcst_ctr_nt_info_h', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
