/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_family_trust_prod_h_irvsf1
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
alter table ${iml_schema}.prd_family_trust_prod_h add partition p_irvsf1 values ('irvsf1')(
        subpartition p_irvsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_irvsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_family_trust_prod_h_irvsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_family_trust_prod_h partition for ('irvsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_family_trust_prod_h_irvsf1_tm purge;
drop table ${iml_schema}.prd_family_trust_prod_h_irvsf1_op purge;
drop table ${iml_schema}.prd_family_trust_prod_h_irvsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_family_trust_prod_h_irvsf1_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,init_prod_id -- 原产品编号
    ,prod_name -- 产品名称
    ,risk_level_cd -- 风险等级代码
    ,acvmnt_base -- 业绩基准
    ,found_dt -- 成立日期
    ,termnt_dt -- 终止日期
    ,prod_status_cd -- 产品状态代码
    ,star_amt -- 起购金额
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,init_setup_amt -- 初始创立金额
    ,lot -- 份额
    ,cost -- 成本
    ,init_mk_val -- 初始市值
    ,trust_corp_cd -- 信托公司代码
    ,trust_corp_name -- 信托公司名称
    ,update_remark -- 更新备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_family_trust_prod_h partition for ('irvsf1')
where 0=1
;

create table ${iml_schema}.prd_family_trust_prod_h_irvsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_family_trust_prod_h partition for ('irvsf1') where 0=1;

create table ${iml_schema}.prd_family_trust_prod_h_irvsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_family_trust_prod_h partition for ('irvsf1') where 0=1;

-- 3.1 get new data into table
-- irvs_ft_product-
insert into ${iml_schema}.prd_family_trust_prod_h_irvsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,init_prod_id -- 原产品编号
    ,prod_name -- 产品名称
    ,risk_level_cd -- 风险等级代码
    ,acvmnt_base -- 业绩基准
    ,found_dt -- 成立日期
    ,termnt_dt -- 终止日期
    ,prod_status_cd -- 产品状态代码
    ,star_amt -- 起购金额
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,init_setup_amt -- 初始创立金额
    ,lot -- 份额
    ,cost -- 成本
    ,init_mk_val -- 初始市值
    ,trust_corp_cd -- 信托公司代码
    ,trust_corp_name -- 信托公司名称
    ,update_remark -- 更新备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223010'||P1.PRODUCT_CODE -- 产品编号
    ,'9999' -- 法人编号
    ,P1.PRODUCT_CODE -- 原产品编号
    ,P1.product_name -- 产品名称
    ,CASE WHEN trim(P1.RISK_GRADE) is null then '-'
     WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.RISK_GRADE END -- 风险等级代码
    ,P1.performance_status -- 业绩基准
    ,${iml_schema}.DATEFORMAT_MIN(P1.establishment_date) -- 成立日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.termination_date) -- 终止日期
    ,CASE WHEN TRIM(P1.PRODUCT_STATUS) IS NULL THEN '-'
     WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.PRODUCT_STATUS END -- 产品状态代码
    ,P1.purchase_amount -- 起购金额
    ,${iml_schema}.DATEFORMAT_MIN(P1.commencement_date) -- 募集开始日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.closing_date) -- 募集结束日期
    ,p1.init_amount -- 初始创立金额
    ,p2.quotient -- 份额
    ,p2.networth_cost -- 成本
    ,p2.networth_marketvalue -- 初始市值
    ,p1.trustcompany_code -- 信托公司代码
    ,p1.trustcompany_name -- 信托公司名称
    ,P3.product_comment -- 更新备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'irvs_ft_product' -- 源表名称
    ,'irvsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.irvs_ft_product p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.RISK_GRADE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IRVS'
        AND R1.SRC_TAB_EN_NAME= 'IRVS_FT_PRODUCT'
        AND R1.SRC_FIELD_EN_NAME= 'RISK_GRADE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_FAMILY_TRUST_PROD_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'RISK_LEVEL_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PRODUCT_STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IRVS'
        AND R2.SRC_TAB_EN_NAME= 'IRVS_FT_PRODUCT'
        AND R2.SRC_FIELD_EN_NAME= 'PRODUCT_STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_FAMILY_TRUST_PROD_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PROD_STATUS_CD'
    left join (select 
product_id
,quotient
,networth_cost
,networth_marketvalue
,row_number() over (partition by product_id order by create_time) as rn
from ${iol_schema}.irvs_ft_networth
where start_dt<=to_date('${batch_date}','yyyymmdd')
and end_dt>to_date('${batch_date}','yyyymmdd')) p2 on P1.PRODUCT_ID=P2.PRODUCT_ID
AND P2.RN=1
    left join ${iol_schema}.irvs_ft_product_history p3 on P3.PRODUCT_ID=P1.PRODUCT_ID
AND P3.CREATED_TIME=P1.UPDATE_TIME
AND P3.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_family_trust_prod_h_irvsf1_tm 
  	                                group by 
  	                                        prod_id
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
        into ${iml_schema}.prd_family_trust_prod_h_irvsf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,init_prod_id -- 原产品编号
    ,prod_name -- 产品名称
    ,risk_level_cd -- 风险等级代码
    ,acvmnt_base -- 业绩基准
    ,found_dt -- 成立日期
    ,termnt_dt -- 终止日期
    ,prod_status_cd -- 产品状态代码
    ,star_amt -- 起购金额
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,init_setup_amt -- 初始创立金额
    ,lot -- 份额
    ,cost -- 成本
    ,init_mk_val -- 初始市值
    ,trust_corp_cd -- 信托公司代码
    ,trust_corp_name -- 信托公司名称
    ,update_remark -- 更新备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_family_trust_prod_h_irvsf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,init_prod_id -- 原产品编号
    ,prod_name -- 产品名称
    ,risk_level_cd -- 风险等级代码
    ,acvmnt_base -- 业绩基准
    ,found_dt -- 成立日期
    ,termnt_dt -- 终止日期
    ,prod_status_cd -- 产品状态代码
    ,star_amt -- 起购金额
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,init_setup_amt -- 初始创立金额
    ,lot -- 份额
    ,cost -- 成本
    ,init_mk_val -- 初始市值
    ,trust_corp_cd -- 信托公司代码
    ,trust_corp_name -- 信托公司名称
    ,update_remark -- 更新备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.init_prod_id, o.init_prod_id) as init_prod_id -- 原产品编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.risk_level_cd, o.risk_level_cd) as risk_level_cd -- 风险等级代码
    ,nvl(n.acvmnt_base, o.acvmnt_base) as acvmnt_base -- 业绩基准
    ,nvl(n.found_dt, o.found_dt) as found_dt -- 成立日期
    ,nvl(n.termnt_dt, o.termnt_dt) as termnt_dt -- 终止日期
    ,nvl(n.prod_status_cd, o.prod_status_cd) as prod_status_cd -- 产品状态代码
    ,nvl(n.star_amt, o.star_amt) as star_amt -- 起购金额
    ,nvl(n.coll_start_dt, o.coll_start_dt) as coll_start_dt -- 募集开始日期
    ,nvl(n.coll_end_dt, o.coll_end_dt) as coll_end_dt -- 募集结束日期
    ,nvl(n.init_setup_amt, o.init_setup_amt) as init_setup_amt -- 初始创立金额
    ,nvl(n.lot, o.lot) as lot -- 份额
    ,nvl(n.cost, o.cost) as cost -- 成本
    ,nvl(n.init_mk_val, o.init_mk_val) as init_mk_val -- 初始市值
    ,nvl(n.trust_corp_cd, o.trust_corp_cd) as trust_corp_cd -- 信托公司代码
    ,nvl(n.trust_corp_name, o.trust_corp_name) as trust_corp_name -- 信托公司名称
    ,nvl(n.update_remark, o.update_remark) as update_remark -- 更新备注
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_family_trust_prod_h_irvsf1_tm n
    full join (select * from ${iml_schema}.prd_family_trust_prod_h_irvsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
where (
        o.prod_id is null
        and o.lp_id is null
    )
    or (
        n.prod_id is null
        and n.lp_id is null
    )
    or (
        o.init_prod_id <> n.init_prod_id
        or o.prod_name <> n.prod_name
        or o.risk_level_cd <> n.risk_level_cd
        or o.acvmnt_base <> n.acvmnt_base
        or o.found_dt <> n.found_dt
        or o.termnt_dt <> n.termnt_dt
        or o.prod_status_cd <> n.prod_status_cd
        or o.star_amt <> n.star_amt
        or o.coll_start_dt <> n.coll_start_dt
        or o.coll_end_dt <> n.coll_end_dt
        or o.init_setup_amt <> n.init_setup_amt
        or o.lot <> n.lot
        or o.cost <> n.cost
        or o.init_mk_val <> n.init_mk_val
        or o.trust_corp_cd <> n.trust_corp_cd
        or o.trust_corp_name <> n.trust_corp_name
        or o.update_remark <> n.update_remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_family_trust_prod_h_irvsf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,init_prod_id -- 原产品编号
    ,prod_name -- 产品名称
    ,risk_level_cd -- 风险等级代码
    ,acvmnt_base -- 业绩基准
    ,found_dt -- 成立日期
    ,termnt_dt -- 终止日期
    ,prod_status_cd -- 产品状态代码
    ,star_amt -- 起购金额
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,init_setup_amt -- 初始创立金额
    ,lot -- 份额
    ,cost -- 成本
    ,init_mk_val -- 初始市值
    ,trust_corp_cd -- 信托公司代码
    ,trust_corp_name -- 信托公司名称
    ,update_remark -- 更新备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_family_trust_prod_h_irvsf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,init_prod_id -- 原产品编号
    ,prod_name -- 产品名称
    ,risk_level_cd -- 风险等级代码
    ,acvmnt_base -- 业绩基准
    ,found_dt -- 成立日期
    ,termnt_dt -- 终止日期
    ,prod_status_cd -- 产品状态代码
    ,star_amt -- 起购金额
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,init_setup_amt -- 初始创立金额
    ,lot -- 份额
    ,cost -- 成本
    ,init_mk_val -- 初始市值
    ,trust_corp_cd -- 信托公司代码
    ,trust_corp_name -- 信托公司名称
    ,update_remark -- 更新备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_id -- 产品编号
    ,o.lp_id -- 法人编号
    ,o.init_prod_id -- 原产品编号
    ,o.prod_name -- 产品名称
    ,o.risk_level_cd -- 风险等级代码
    ,o.acvmnt_base -- 业绩基准
    ,o.found_dt -- 成立日期
    ,o.termnt_dt -- 终止日期
    ,o.prod_status_cd -- 产品状态代码
    ,o.star_amt -- 起购金额
    ,o.coll_start_dt -- 募集开始日期
    ,o.coll_end_dt -- 募集结束日期
    ,o.init_setup_amt -- 初始创立金额
    ,o.lot -- 份额
    ,o.cost -- 成本
    ,o.init_mk_val -- 初始市值
    ,o.trust_corp_cd -- 信托公司代码
    ,o.trust_corp_name -- 信托公司名称
    ,o.update_remark -- 更新备注
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
from ${iml_schema}.prd_family_trust_prod_h_irvsf1_bk o
    left join ${iml_schema}.prd_family_trust_prod_h_irvsf1_op n
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_family_trust_prod_h_irvsf1_cl d
        on
            o.prod_id = d.prod_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_family_trust_prod_h;
--alter table ${iml_schema}.prd_family_trust_prod_h truncate partition for ('irvsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('prd_family_trust_prod_h') 
               and substr(subpartition_name,1,8)=upper('p_irvsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.prd_family_trust_prod_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.prd_family_trust_prod_h modify partition p_irvsf1 
add subpartition p_irvsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.prd_family_trust_prod_h exchange subpartition p_irvsf1_${batch_date} with table ${iml_schema}.prd_family_trust_prod_h_irvsf1_cl;
alter table ${iml_schema}.prd_family_trust_prod_h exchange subpartition p_irvsf1_20991231 with table ${iml_schema}.prd_family_trust_prod_h_irvsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_family_trust_prod_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_family_trust_prod_h_irvsf1_tm purge;
drop table ${iml_schema}.prd_family_trust_prod_h_irvsf1_op purge;
drop table ${iml_schema}.prd_family_trust_prod_h_irvsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_family_trust_prod_h_irvsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_family_trust_prod_h', partname => 'p_irvsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
