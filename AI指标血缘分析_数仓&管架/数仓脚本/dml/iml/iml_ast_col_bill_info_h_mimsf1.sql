/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_bill_info_h_mimsf1
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
alter table ${iml_schema}.ast_col_bill_info_h add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mimsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_bill_info_h_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_bill_info_h partition for ('mimsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ast_col_bill_info_h_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_bill_info_h_mimsf1_op purge;
drop table ${iml_schema}.ast_col_bill_info_h_mimsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_bill_info_h_mimsf1_tm nologging
compress ${option_switch} for query high
as select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_id -- 押品编号
    ,bill_num -- 票据号码
    ,bill_type_cd -- 票据类型代码
    ,drawer_name -- 出票人名称
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_type_cd -- 出票人类型代码
    ,drawer_open_bank_bank_id -- 出票人开户行银行编号
    ,drawer_acct_num -- 出票人账号
    ,recver_name -- 收款人名称
    ,recver_type_cd -- 收款人类型代码
    ,bill_rher_flg -- 票据前手标志
    ,bill_rher_name -- 票据前手名称
    ,bill_rher_type_cd -- 票据前手类型代码
    ,fac_val_amt -- 票面金额
    ,bill_issue_dt -- 票据签发日期
    ,bill_exp_dt -- 票据到期日期
    ,drawer_local_cty_or_rg_cd -- 出票人所在国家或地区代码
    ,drawer_ext_rating_rest_cd -- 出票人外部评级结果代码
    ,bank_ensure_discount_flg -- 银行保贴标志
    ,bank_ensure_discount_name -- 银行保贴名称
    ,curr_cd -- 币种代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_bill_info_h partition for ('mimsf1')
where 0=1
;

create table ${iml_schema}.ast_col_bill_info_h_mimsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_bill_info_h partition for ('mimsf1') where 0=1;

create table ${iml_schema}.ast_col_bill_info_h_mimsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_bill_info_h partition for ('mimsf1') where 0=1;

-- 3.1 get new data into table
-- mims_si_bill-
insert into ${iml_schema}.ast_col_bill_info_h_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_id -- 押品编号
    ,bill_num -- 票据号码
    ,bill_type_cd -- 票据类型代码
    ,drawer_name -- 出票人名称
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_type_cd -- 出票人类型代码
    ,drawer_open_bank_bank_id -- 出票人开户行银行编号
    ,drawer_acct_num -- 出票人账号
    ,recver_name -- 收款人名称
    ,recver_type_cd -- 收款人类型代码
    ,bill_rher_flg -- 票据前手标志
    ,bill_rher_name -- 票据前手名称
    ,bill_rher_type_cd -- 票据前手类型代码
    ,fac_val_amt -- 票面金额
    ,bill_issue_dt -- 票据签发日期
    ,bill_exp_dt -- 票据到期日期
    ,drawer_local_cty_or_rg_cd -- 出票人所在国家或地区代码
    ,drawer_ext_rating_rest_cd -- 出票人外部评级结果代码
    ,bank_ensure_discount_flg -- 银行保贴标志
    ,bank_ensure_discount_name -- 银行保贴名称
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '500002'||p1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,p1.SCCODE -- 押品编号
    ,p1.NOTECODE -- 票据号码
    ,case when R1.TARGET_CD_VAL is not null then R1.TARGET_CD_VAL else '@'||p1.NOTETYPE end -- 票据类型代码
    ,p1.REMITTER -- 出票人名称
    ,p1.REMITTERCODE -- 出票人组织机构代码
    ,NVL(TRIM(p1.REMITTERTYPE),'00') -- 出票人类型代码
    ,p1.REMITTEROPENACOUNT -- 出票人开户行银行编号
    ,p1.REMITTERACCOUNT -- 出票人账号
    ,p1.PAYEE -- 收款人名称
    ,NVL(TRIM(p1.PAYEETYPE),'00') -- 收款人类型代码
    ,NVL(TRIM(p1.ISBILLBHAND),'-') -- 票据前手标志
    ,p1.BILLBHANDNAME -- 票据前手名称
    ,NVL(TRIM(p1.BILLBHANDTYPE),'00') -- 票据前手类型代码
    ,p1.FACEAMOUNT -- 票面金额
    ,${iml_schema}.DATEFORMAT_MIN(p1.STARTDATE) -- 票据签发日期
    ,${iml_schema}.DATEFORMAT_MIN(p1.ENDDATE) -- 票据到期日期
    ,nvl(trim(p1.REMITTERCOUNTRY),'XXX') -- 出票人所在国家或地区代码
    ,nvl(trim(p1.REMITTERRATING),'-') -- 出票人外部评级结果代码
    ,nvl(trim(p1.ISBANKPASTE),'-') -- 银行保贴标志
    ,p1.BANKPASTENAME -- 银行保贴名称
    ,nvl(trim(p1.TDCURRENCY),'-') -- 币种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_bill' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_bill p1
    left join ${iml_schema}.ref_pub_cd_map r1 on nvl(P1.NOTETYPE,' ')= R1.SRC_CODE_VAL                                
        AND R1.SORC_SYS_CD= 'MIMS'                          
        AND R1.SRC_TAB_EN_NAME= 'MIMS_SI_BILL'               
        AND R1.SRC_FIELD_EN_NAME= 'NOTETYPE'                 
        AND R1.TARGET_TAB_EN_NAME= 'AST_COL_BILL_INFO_H'       
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BILL_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_bill_info_h_mimsf1_tm 
  	                                group by 
  	                                        asset_id
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
        into ${iml_schema}.ast_col_bill_info_h_mimsf1_cl(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_id -- 押品编号
    ,bill_num -- 票据号码
    ,bill_type_cd -- 票据类型代码
    ,drawer_name -- 出票人名称
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_type_cd -- 出票人类型代码
    ,drawer_open_bank_bank_id -- 出票人开户行银行编号
    ,drawer_acct_num -- 出票人账号
    ,recver_name -- 收款人名称
    ,recver_type_cd -- 收款人类型代码
    ,bill_rher_flg -- 票据前手标志
    ,bill_rher_name -- 票据前手名称
    ,bill_rher_type_cd -- 票据前手类型代码
    ,fac_val_amt -- 票面金额
    ,bill_issue_dt -- 票据签发日期
    ,bill_exp_dt -- 票据到期日期
    ,drawer_local_cty_or_rg_cd -- 出票人所在国家或地区代码
    ,drawer_ext_rating_rest_cd -- 出票人外部评级结果代码
    ,bank_ensure_discount_flg -- 银行保贴标志
    ,bank_ensure_discount_name -- 银行保贴名称
    ,curr_cd -- 币种代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_bill_info_h_mimsf1_op(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_id -- 押品编号
    ,bill_num -- 票据号码
    ,bill_type_cd -- 票据类型代码
    ,drawer_name -- 出票人名称
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_type_cd -- 出票人类型代码
    ,drawer_open_bank_bank_id -- 出票人开户行银行编号
    ,drawer_acct_num -- 出票人账号
    ,recver_name -- 收款人名称
    ,recver_type_cd -- 收款人类型代码
    ,bill_rher_flg -- 票据前手标志
    ,bill_rher_name -- 票据前手名称
    ,bill_rher_type_cd -- 票据前手类型代码
    ,fac_val_amt -- 票面金额
    ,bill_issue_dt -- 票据签发日期
    ,bill_exp_dt -- 票据到期日期
    ,drawer_local_cty_or_rg_cd -- 出票人所在国家或地区代码
    ,drawer_ext_rating_rest_cd -- 出票人外部评级结果代码
    ,bank_ensure_discount_flg -- 银行保贴标志
    ,bank_ensure_discount_name -- 银行保贴名称
    ,curr_cd -- 币种代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.col_id, o.col_id) as col_id -- 押品编号
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.drawer_name, o.drawer_name) as drawer_name -- 出票人名称
    ,nvl(n.drawer_orgnz_cd, o.drawer_orgnz_cd) as drawer_orgnz_cd -- 出票人组织机构代码
    ,nvl(n.drawer_type_cd, o.drawer_type_cd) as drawer_type_cd -- 出票人类型代码
    ,nvl(n.drawer_open_bank_bank_id, o.drawer_open_bank_bank_id) as drawer_open_bank_bank_id -- 出票人开户行银行编号
    ,nvl(n.drawer_acct_num, o.drawer_acct_num) as drawer_acct_num -- 出票人账号
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 收款人名称
    ,nvl(n.recver_type_cd, o.recver_type_cd) as recver_type_cd -- 收款人类型代码
    ,nvl(n.bill_rher_flg, o.bill_rher_flg) as bill_rher_flg -- 票据前手标志
    ,nvl(n.bill_rher_name, o.bill_rher_name) as bill_rher_name -- 票据前手名称
    ,nvl(n.bill_rher_type_cd, o.bill_rher_type_cd) as bill_rher_type_cd -- 票据前手类型代码
    ,nvl(n.fac_val_amt, o.fac_val_amt) as fac_val_amt -- 票面金额
    ,nvl(n.bill_issue_dt, o.bill_issue_dt) as bill_issue_dt -- 票据签发日期
    ,nvl(n.bill_exp_dt, o.bill_exp_dt) as bill_exp_dt -- 票据到期日期
    ,nvl(n.drawer_local_cty_or_rg_cd, o.drawer_local_cty_or_rg_cd) as drawer_local_cty_or_rg_cd -- 出票人所在国家或地区代码
    ,nvl(n.drawer_ext_rating_rest_cd, o.drawer_ext_rating_rest_cd) as drawer_ext_rating_rest_cd -- 出票人外部评级结果代码
    ,nvl(n.bank_ensure_discount_flg, o.bank_ensure_discount_flg) as bank_ensure_discount_flg -- 银行保贴标志
    ,nvl(n.bank_ensure_discount_name, o.bank_ensure_discount_name) as bank_ensure_discount_name -- 银行保贴名称
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,case when
            n.asset_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.asset_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.asset_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_bill_info_h_mimsf1_tm n
    full join (select * from ${iml_schema}.ast_col_bill_info_h_mimsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
where (
        o.asset_id is null
        and o.lp_id is null
    )
    or (
        n.asset_id is null
        and n.lp_id is null
    )
    or (
        o.col_id <> n.col_id
        or o.bill_num <> n.bill_num
        or o.bill_type_cd <> n.bill_type_cd
        or o.drawer_name <> n.drawer_name
        or o.drawer_orgnz_cd <> n.drawer_orgnz_cd
        or o.drawer_type_cd <> n.drawer_type_cd
        or o.drawer_open_bank_bank_id <> n.drawer_open_bank_bank_id
        or o.drawer_acct_num <> n.drawer_acct_num
        or o.recver_name <> n.recver_name
        or o.recver_type_cd <> n.recver_type_cd
        or o.bill_rher_flg <> n.bill_rher_flg
        or o.bill_rher_name <> n.bill_rher_name
        or o.bill_rher_type_cd <> n.bill_rher_type_cd
        or o.fac_val_amt <> n.fac_val_amt
        or o.bill_issue_dt <> n.bill_issue_dt
        or o.bill_exp_dt <> n.bill_exp_dt
        or o.drawer_local_cty_or_rg_cd <> n.drawer_local_cty_or_rg_cd
        or o.drawer_ext_rating_rest_cd <> n.drawer_ext_rating_rest_cd
        or o.bank_ensure_discount_flg <> n.bank_ensure_discount_flg
        or o.bank_ensure_discount_name <> n.bank_ensure_discount_name
        or o.curr_cd <> n.curr_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_col_bill_info_h_mimsf1_cl(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_id -- 押品编号
    ,bill_num -- 票据号码
    ,bill_type_cd -- 票据类型代码
    ,drawer_name -- 出票人名称
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_type_cd -- 出票人类型代码
    ,drawer_open_bank_bank_id -- 出票人开户行银行编号
    ,drawer_acct_num -- 出票人账号
    ,recver_name -- 收款人名称
    ,recver_type_cd -- 收款人类型代码
    ,bill_rher_flg -- 票据前手标志
    ,bill_rher_name -- 票据前手名称
    ,bill_rher_type_cd -- 票据前手类型代码
    ,fac_val_amt -- 票面金额
    ,bill_issue_dt -- 票据签发日期
    ,bill_exp_dt -- 票据到期日期
    ,drawer_local_cty_or_rg_cd -- 出票人所在国家或地区代码
    ,drawer_ext_rating_rest_cd -- 出票人外部评级结果代码
    ,bank_ensure_discount_flg -- 银行保贴标志
    ,bank_ensure_discount_name -- 银行保贴名称
    ,curr_cd -- 币种代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_bill_info_h_mimsf1_op(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,col_id -- 押品编号
    ,bill_num -- 票据号码
    ,bill_type_cd -- 票据类型代码
    ,drawer_name -- 出票人名称
    ,drawer_orgnz_cd -- 出票人组织机构代码
    ,drawer_type_cd -- 出票人类型代码
    ,drawer_open_bank_bank_id -- 出票人开户行银行编号
    ,drawer_acct_num -- 出票人账号
    ,recver_name -- 收款人名称
    ,recver_type_cd -- 收款人类型代码
    ,bill_rher_flg -- 票据前手标志
    ,bill_rher_name -- 票据前手名称
    ,bill_rher_type_cd -- 票据前手类型代码
    ,fac_val_amt -- 票面金额
    ,bill_issue_dt -- 票据签发日期
    ,bill_exp_dt -- 票据到期日期
    ,drawer_local_cty_or_rg_cd -- 出票人所在国家或地区代码
    ,drawer_ext_rating_rest_cd -- 出票人外部评级结果代码
    ,bank_ensure_discount_flg -- 银行保贴标志
    ,bank_ensure_discount_name -- 银行保贴名称
    ,curr_cd -- 币种代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.asset_id -- 资产编号
    ,o.lp_id -- 法人编号
    ,o.col_id -- 押品编号
    ,o.bill_num -- 票据号码
    ,o.bill_type_cd -- 票据类型代码
    ,o.drawer_name -- 出票人名称
    ,o.drawer_orgnz_cd -- 出票人组织机构代码
    ,o.drawer_type_cd -- 出票人类型代码
    ,o.drawer_open_bank_bank_id -- 出票人开户行银行编号
    ,o.drawer_acct_num -- 出票人账号
    ,o.recver_name -- 收款人名称
    ,o.recver_type_cd -- 收款人类型代码
    ,o.bill_rher_flg -- 票据前手标志
    ,o.bill_rher_name -- 票据前手名称
    ,o.bill_rher_type_cd -- 票据前手类型代码
    ,o.fac_val_amt -- 票面金额
    ,o.bill_issue_dt -- 票据签发日期
    ,o.bill_exp_dt -- 票据到期日期
    ,o.drawer_local_cty_or_rg_cd -- 出票人所在国家或地区代码
    ,o.drawer_ext_rating_rest_cd -- 出票人外部评级结果代码
    ,o.bank_ensure_discount_flg -- 银行保贴标志
    ,o.bank_ensure_discount_name -- 银行保贴名称
    ,o.curr_cd -- 币种代码
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
from ${iml_schema}.ast_col_bill_info_h_mimsf1_bk o
    left join ${iml_schema}.ast_col_bill_info_h_mimsf1_op n
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ast_col_bill_info_h_mimsf1_cl d
        on
            o.asset_id = d.asset_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ast_col_bill_info_h;
--alter table ${iml_schema}.ast_col_bill_info_h truncate partition for ('mimsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ast_col_bill_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mimsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ast_col_bill_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ast_col_bill_info_h modify partition p_mimsf1 
add subpartition p_mimsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ast_col_bill_info_h exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_col_bill_info_h_mimsf1_cl;
alter table ${iml_schema}.ast_col_bill_info_h exchange subpartition p_mimsf1_20991231 with table ${iml_schema}.ast_col_bill_info_h_mimsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_bill_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_col_bill_info_h_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_bill_info_h_mimsf1_op purge;
drop table ${iml_schema}.ast_col_bill_info_h_mimsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ast_col_bill_info_h_mimsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_bill_info_h', partname => 'p_mimsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
