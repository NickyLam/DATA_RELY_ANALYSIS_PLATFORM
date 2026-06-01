/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_trust_prod_acct_num_info_h_trusf1
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
alter table ${iml_schema}.prd_trust_prod_acct_num_info_h add partition p_trusf1 values ('trusf1')(
        subpartition p_trusf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_trusf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_trust_prod_acct_num_info_h partition for ('trusf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_tm purge;
drop table ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_op purge;
drop table ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_tm nologging
compress ${option_switch} for query high
as select
    ta_cd -- TA代码
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,cap_veri_acct_open_bank_cd -- 验资户开户行代码
    ,rgst_rgst_acct_open_bank_cd -- 注册登记账户开户行代码
    ,make_acct_bank_acct_num -- 上账银行账号
    ,keep_acct_bank_acct_num -- 下账银行账号
    ,coll_cap_vrfction_acct -- 募集验资账户
    ,coll_cap_vrfction_acct_name -- 募集验资账户名称
    ,trust_corp_prod_id -- 信托公司产品编号
    ,stl_type_cd -- 结算类型代码
    ,trust_bank_name -- 托管银行名称
    ,trust_org_name -- 托管机构名称
    ,prod_name -- 产品名称
    ,make_acct_bank_acct_num_name -- 上账银行账号名称
    ,keep_acct_bank_acct_num_name -- 下账银行账号名称
    ,resv_field_1 -- 备用字段1
    ,resv_field_2 -- 备用字段2
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_trust_prod_acct_num_info_h partition for ('trusf1')
where 0=1
;

create table ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_trust_prod_acct_num_info_h partition for ('trusf1') where 0=1;

create table ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_trust_prod_acct_num_info_h partition for ('trusf1') where 0=1;

-- 3.1 get new data into table
-- nfss_tcs_tbprdbankacc-
insert into ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_tm(
     ta_cd -- TA代码
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,cap_veri_acct_open_bank_cd -- 验资户开户行代码
    ,rgst_rgst_acct_open_bank_cd -- 注册登记账户开户行代码
    ,make_acct_bank_acct_num -- 上账银行账号
    ,keep_acct_bank_acct_num -- 下账银行账号
    ,coll_cap_vrfction_acct -- 募集验资账户
    ,coll_cap_vrfction_acct_name -- 募集验资账户名称
    ,trust_corp_prod_id -- 信托公司产品编号
    ,stl_type_cd -- 结算类型代码
    ,trust_bank_name -- 托管银行名称
    ,trust_org_name -- 托管机构名称
    ,prod_name -- 产品名称
    ,make_acct_bank_acct_num_name -- 上账银行账号名称
    ,keep_acct_bank_acct_num_name -- 下账银行账号名称
    ,resv_field_1 -- 备用字段1
    ,resv_field_2 -- 备用字段2
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.TA_CODE -- TA代码
    ,'9999' -- 法人编号
    ,P1.PRD_CODE -- 产品编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.OPEN_BANK_VER END -- 验资户开户行代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.OPEN_BANK_UP END -- 注册登记账户开户行代码
    ,P1.BANK_ACC_UP -- 上账银行账号
    ,P1.BANK_ACC_DOWN -- 下账银行账号
    ,P1.BANK_ACC_VER -- 募集验资账户
    ,P1.BANK_ACC_VER_NAME -- 募集验资账户名称
    ,P1.ASSO_CODE -- 信托公司产品编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.SQUARE_WAY END -- 结算类型代码
    ,P1.BANK_NAME -- 托管银行名称
    ,P1.BRANCH_NAME -- 托管机构名称
    ,P1.PRD_NAME -- 产品名称
    ,P1.BANK_ACC_UP_NAME -- 上账银行账号名称
    ,P1.BANK_ACC_DOWN_NAME -- 下账银行账号名称
    ,P1.RESERVE1 -- 备用字段1
    ,P1.RESERVE2 -- 备用字段2
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_tcs_tbprdbankacc' -- 源表名称
    ,'trusf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_tcs_tbprdbankacc p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.OPEN_BANK_VER= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NFSS'
        AND R1.SRC_TAB_EN_NAME= 'NFSS_TCS_TBPRDBANKACC'
        AND R1.SRC_FIELD_EN_NAME= 'OPEN_BANK_VER'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_TRUST_PROD_ACCT_NUM_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CAP_VERI_ACCT_OPEN_BANK_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.OPEN_BANK_UP= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'NFSS'
        AND R2.SRC_TAB_EN_NAME= 'NFSS_TCS_TBPRDBANKACC'
        AND R2.SRC_FIELD_EN_NAME= 'OPEN_BANK_UP'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_TRUST_PROD_ACCT_NUM_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'RGST_RGST_ACCT_OPEN_BANK_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.SQUARE_WAY= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'NFSS'
        AND R3.SRC_TAB_EN_NAME= 'NFSS_TCS_TBPRDBANKACC'
        AND R3.SRC_FIELD_EN_NAME= 'SQUARE_WAY'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_TRUST_PROD_ACCT_NUM_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'STL_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_tm 
  	                                group by 
  	                                        lp_id
  	                                        ,prod_id
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
        into ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_cl(
            ta_cd -- TA代码
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,cap_veri_acct_open_bank_cd -- 验资户开户行代码
    ,rgst_rgst_acct_open_bank_cd -- 注册登记账户开户行代码
    ,make_acct_bank_acct_num -- 上账银行账号
    ,keep_acct_bank_acct_num -- 下账银行账号
    ,coll_cap_vrfction_acct -- 募集验资账户
    ,coll_cap_vrfction_acct_name -- 募集验资账户名称
    ,trust_corp_prod_id -- 信托公司产品编号
    ,stl_type_cd -- 结算类型代码
    ,trust_bank_name -- 托管银行名称
    ,trust_org_name -- 托管机构名称
    ,prod_name -- 产品名称
    ,make_acct_bank_acct_num_name -- 上账银行账号名称
    ,keep_acct_bank_acct_num_name -- 下账银行账号名称
    ,resv_field_1 -- 备用字段1
    ,resv_field_2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_op(
            ta_cd -- TA代码
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,cap_veri_acct_open_bank_cd -- 验资户开户行代码
    ,rgst_rgst_acct_open_bank_cd -- 注册登记账户开户行代码
    ,make_acct_bank_acct_num -- 上账银行账号
    ,keep_acct_bank_acct_num -- 下账银行账号
    ,coll_cap_vrfction_acct -- 募集验资账户
    ,coll_cap_vrfction_acct_name -- 募集验资账户名称
    ,trust_corp_prod_id -- 信托公司产品编号
    ,stl_type_cd -- 结算类型代码
    ,trust_bank_name -- 托管银行名称
    ,trust_org_name -- 托管机构名称
    ,prod_name -- 产品名称
    ,make_acct_bank_acct_num_name -- 上账银行账号名称
    ,keep_acct_bank_acct_num_name -- 下账银行账号名称
    ,resv_field_1 -- 备用字段1
    ,resv_field_2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.cap_veri_acct_open_bank_cd, o.cap_veri_acct_open_bank_cd) as cap_veri_acct_open_bank_cd -- 验资户开户行代码
    ,nvl(n.rgst_rgst_acct_open_bank_cd, o.rgst_rgst_acct_open_bank_cd) as rgst_rgst_acct_open_bank_cd -- 注册登记账户开户行代码
    ,nvl(n.make_acct_bank_acct_num, o.make_acct_bank_acct_num) as make_acct_bank_acct_num -- 上账银行账号
    ,nvl(n.keep_acct_bank_acct_num, o.keep_acct_bank_acct_num) as keep_acct_bank_acct_num -- 下账银行账号
    ,nvl(n.coll_cap_vrfction_acct, o.coll_cap_vrfction_acct) as coll_cap_vrfction_acct -- 募集验资账户
    ,nvl(n.coll_cap_vrfction_acct_name, o.coll_cap_vrfction_acct_name) as coll_cap_vrfction_acct_name -- 募集验资账户名称
    ,nvl(n.trust_corp_prod_id, o.trust_corp_prod_id) as trust_corp_prod_id -- 信托公司产品编号
    ,nvl(n.stl_type_cd, o.stl_type_cd) as stl_type_cd -- 结算类型代码
    ,nvl(n.trust_bank_name, o.trust_bank_name) as trust_bank_name -- 托管银行名称
    ,nvl(n.trust_org_name, o.trust_org_name) as trust_org_name -- 托管机构名称
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.make_acct_bank_acct_num_name, o.make_acct_bank_acct_num_name) as make_acct_bank_acct_num_name -- 上账银行账号名称
    ,nvl(n.keep_acct_bank_acct_num_name, o.keep_acct_bank_acct_num_name) as keep_acct_bank_acct_num_name -- 下账银行账号名称
    ,nvl(n.resv_field_1, o.resv_field_1) as resv_field_1 -- 备用字段1
    ,nvl(n.resv_field_2, o.resv_field_2) as resv_field_2 -- 备用字段2
    ,case when
            n.lp_id is null
            and n.prod_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.lp_id is null
            and n.prod_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.lp_id is null
            and n.prod_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_tm n
    full join (select * from ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.lp_id = n.lp_id
            and o.prod_id = n.prod_id
where (
        o.lp_id is null
        and o.prod_id is null
    )
    or (
        n.lp_id is null
        and n.prod_id is null
    )
    or (
        o.ta_cd <> n.ta_cd
        or o.cap_veri_acct_open_bank_cd <> n.cap_veri_acct_open_bank_cd
        or o.rgst_rgst_acct_open_bank_cd <> n.rgst_rgst_acct_open_bank_cd
        or o.make_acct_bank_acct_num <> n.make_acct_bank_acct_num
        or o.keep_acct_bank_acct_num <> n.keep_acct_bank_acct_num
        or o.coll_cap_vrfction_acct <> n.coll_cap_vrfction_acct
        or o.coll_cap_vrfction_acct_name <> n.coll_cap_vrfction_acct_name
        or o.trust_corp_prod_id <> n.trust_corp_prod_id
        or o.stl_type_cd <> n.stl_type_cd
        or o.trust_bank_name <> n.trust_bank_name
        or o.trust_org_name <> n.trust_org_name
        or o.prod_name <> n.prod_name
        or o.make_acct_bank_acct_num_name <> n.make_acct_bank_acct_num_name
        or o.keep_acct_bank_acct_num_name <> n.keep_acct_bank_acct_num_name
        or o.resv_field_1 <> n.resv_field_1
        or o.resv_field_2 <> n.resv_field_2
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_cl(
            ta_cd -- TA代码
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,cap_veri_acct_open_bank_cd -- 验资户开户行代码
    ,rgst_rgst_acct_open_bank_cd -- 注册登记账户开户行代码
    ,make_acct_bank_acct_num -- 上账银行账号
    ,keep_acct_bank_acct_num -- 下账银行账号
    ,coll_cap_vrfction_acct -- 募集验资账户
    ,coll_cap_vrfction_acct_name -- 募集验资账户名称
    ,trust_corp_prod_id -- 信托公司产品编号
    ,stl_type_cd -- 结算类型代码
    ,trust_bank_name -- 托管银行名称
    ,trust_org_name -- 托管机构名称
    ,prod_name -- 产品名称
    ,make_acct_bank_acct_num_name -- 上账银行账号名称
    ,keep_acct_bank_acct_num_name -- 下账银行账号名称
    ,resv_field_1 -- 备用字段1
    ,resv_field_2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_op(
            ta_cd -- TA代码
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,cap_veri_acct_open_bank_cd -- 验资户开户行代码
    ,rgst_rgst_acct_open_bank_cd -- 注册登记账户开户行代码
    ,make_acct_bank_acct_num -- 上账银行账号
    ,keep_acct_bank_acct_num -- 下账银行账号
    ,coll_cap_vrfction_acct -- 募集验资账户
    ,coll_cap_vrfction_acct_name -- 募集验资账户名称
    ,trust_corp_prod_id -- 信托公司产品编号
    ,stl_type_cd -- 结算类型代码
    ,trust_bank_name -- 托管银行名称
    ,trust_org_name -- 托管机构名称
    ,prod_name -- 产品名称
    ,make_acct_bank_acct_num_name -- 上账银行账号名称
    ,keep_acct_bank_acct_num_name -- 下账银行账号名称
    ,resv_field_1 -- 备用字段1
    ,resv_field_2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ta_cd -- TA代码
    ,o.lp_id -- 法人编号
    ,o.prod_id -- 产品编号
    ,o.cap_veri_acct_open_bank_cd -- 验资户开户行代码
    ,o.rgst_rgst_acct_open_bank_cd -- 注册登记账户开户行代码
    ,o.make_acct_bank_acct_num -- 上账银行账号
    ,o.keep_acct_bank_acct_num -- 下账银行账号
    ,o.coll_cap_vrfction_acct -- 募集验资账户
    ,o.coll_cap_vrfction_acct_name -- 募集验资账户名称
    ,o.trust_corp_prod_id -- 信托公司产品编号
    ,o.stl_type_cd -- 结算类型代码
    ,o.trust_bank_name -- 托管银行名称
    ,o.trust_org_name -- 托管机构名称
    ,o.prod_name -- 产品名称
    ,o.make_acct_bank_acct_num_name -- 上账银行账号名称
    ,o.keep_acct_bank_acct_num_name -- 下账银行账号名称
    ,o.resv_field_1 -- 备用字段1
    ,o.resv_field_2 -- 备用字段2
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
from ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_bk o
    left join ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_op n
        on
            o.lp_id = n.lp_id
            and o.prod_id = n.prod_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_cl d
        on
            o.lp_id = d.lp_id
            and o.prod_id = d.prod_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_trust_prod_acct_num_info_h;
--alter table ${iml_schema}.prd_trust_prod_acct_num_info_h truncate partition for ('trusf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('prd_trust_prod_acct_num_info_h') 
               and substr(subpartition_name,1,8)=upper('p_trusf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.prd_trust_prod_acct_num_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.prd_trust_prod_acct_num_info_h modify partition p_trusf1 
add subpartition p_trusf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.prd_trust_prod_acct_num_info_h exchange subpartition p_trusf1_${batch_date} with table ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_cl;
alter table ${iml_schema}.prd_trust_prod_acct_num_info_h exchange subpartition p_trusf1_20991231 with table ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_trust_prod_acct_num_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_tm purge;
drop table ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_op purge;
drop table ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_trust_prod_acct_num_info_h_trusf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_trust_prod_acct_num_info_h', partname => 'p_trusf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
