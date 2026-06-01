/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_overs_remit_appl_base_info_h_isbsf1
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
alter table ${iml_schema}.agt_overs_remit_appl_base_info_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_overs_remit_appl_base_info_h partition for ('isbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_op purge;
drop table ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,decl_id -- 申报编号
    ,temp_decl_flow_id -- 临时申报流水编号
    ,init_enty_id -- 原始实体编号
    ,edit_id -- 版本编号
    ,oper_type_cd -- 操作类型代码
    ,modif_rs_descb -- 变更原因描述
    ,decl_num -- 申报号码
    ,remiter_type_cd -- 汇款人类型代码
    ,indv_id_card_piece_no_code -- 个人身份证件号码
    ,orgnz_id -- 组织机构编号
    ,remiter_name -- 汇款人名称
    ,recver_name -- 收款人名称
    ,remit_curr_cd -- 汇款币种代码
    ,remit_amt -- 汇款金额
    ,exch_rat -- 汇率
    ,foreign_exch_pur_amt -- 购汇金额
    ,cny_acct_id -- 人民币账户编号
    ,spot_exch_amt -- 现汇金额
    ,fx_acct_id -- 外汇账户编号
    ,other_amt -- 其他金额
    ,other_acct_id -- 其它账户编号
    ,stl_way_cd -- 结算方式代码
    ,bank_bus_id -- 银行业务编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_overs_remit_appl_base_info_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_overs_remit_appl_base_info_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_overs_remit_appl_base_info_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_dbb-1
insert into ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,decl_id -- 申报编号
    ,temp_decl_flow_id -- 临时申报流水编号
    ,init_enty_id -- 原始实体编号
    ,edit_id -- 版本编号
    ,oper_type_cd -- 操作类型代码
    ,modif_rs_descb -- 变更原因描述
    ,decl_num -- 申报号码
    ,remiter_type_cd -- 汇款人类型代码
    ,indv_id_card_piece_no_code -- 个人身份证件号码
    ,orgnz_id -- 组织机构编号
    ,remiter_name -- 汇款人名称
    ,recver_name -- 收款人名称
    ,remit_curr_cd -- 汇款币种代码
    ,remit_amt -- 汇款金额
    ,exch_rat -- 汇率
    ,foreign_exch_pur_amt -- 购汇金额
    ,cny_acct_id -- 人民币账户编号
    ,spot_exch_amt -- 现汇金额
    ,fx_acct_id -- 外汇账户编号
    ,other_amt -- 其他金额
    ,other_acct_id -- 其它账户编号
    ,stl_way_cd -- 结算方式代码
    ,bank_bus_id -- 银行业务编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '226201'||P1.INR -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INR -- 申报编号
    ,P1.TMPREF -- 临时申报流水编号
    ,P1.OWNEXTKEY -- 原始实体编号
    ,P1.VER -- 版本编号
    ,nvl(trim(P1.ACTIONTYPE),'-') -- 操作类型代码
    ,P1.ACTIONDESC -- 变更原因描述
    ,P1.RPTNO -- 申报号码
    ,nvl(trim(P1.CUSTYPE),'-') -- 汇款人类型代码
    ,P1.IDCODE -- 个人身份证件号码
    ,P1.CUSTCOD -- 组织机构编号
    ,P1.CUSTNM -- 汇款人名称
    ,P1.OPPUSER -- 收款人名称
    ,P1.TXCCY -- 汇款币种代码
    ,P1.TXAMT -- 汇款金额
    ,P1.EXRATE -- 汇率
    ,P1.LCYAMT -- 购汇金额
    ,P1.LCYACC -- 人民币账户编号
    ,P1.FCYAMT -- 现汇金额
    ,P1.FCYACC -- 外汇账户编号
    ,P1.OTHAMT -- 其他金额
    ,P1.OTHACC -- 其它账户编号
    ,nvl(trim(P1.METHODS),'-') -- 结算方式代码
    ,P1.BUSCODE -- 银行业务编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_dbb' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_dbb p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,decl_id
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
        into ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,decl_id -- 申报编号
    ,temp_decl_flow_id -- 临时申报流水编号
    ,init_enty_id -- 原始实体编号
    ,edit_id -- 版本编号
    ,oper_type_cd -- 操作类型代码
    ,modif_rs_descb -- 变更原因描述
    ,decl_num -- 申报号码
    ,remiter_type_cd -- 汇款人类型代码
    ,indv_id_card_piece_no_code -- 个人身份证件号码
    ,orgnz_id -- 组织机构编号
    ,remiter_name -- 汇款人名称
    ,recver_name -- 收款人名称
    ,remit_curr_cd -- 汇款币种代码
    ,remit_amt -- 汇款金额
    ,exch_rat -- 汇率
    ,foreign_exch_pur_amt -- 购汇金额
    ,cny_acct_id -- 人民币账户编号
    ,spot_exch_amt -- 现汇金额
    ,fx_acct_id -- 外汇账户编号
    ,other_amt -- 其他金额
    ,other_acct_id -- 其它账户编号
    ,stl_way_cd -- 结算方式代码
    ,bank_bus_id -- 银行业务编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,decl_id -- 申报编号
    ,temp_decl_flow_id -- 临时申报流水编号
    ,init_enty_id -- 原始实体编号
    ,edit_id -- 版本编号
    ,oper_type_cd -- 操作类型代码
    ,modif_rs_descb -- 变更原因描述
    ,decl_num -- 申报号码
    ,remiter_type_cd -- 汇款人类型代码
    ,indv_id_card_piece_no_code -- 个人身份证件号码
    ,orgnz_id -- 组织机构编号
    ,remiter_name -- 汇款人名称
    ,recver_name -- 收款人名称
    ,remit_curr_cd -- 汇款币种代码
    ,remit_amt -- 汇款金额
    ,exch_rat -- 汇率
    ,foreign_exch_pur_amt -- 购汇金额
    ,cny_acct_id -- 人民币账户编号
    ,spot_exch_amt -- 现汇金额
    ,fx_acct_id -- 外汇账户编号
    ,other_amt -- 其他金额
    ,other_acct_id -- 其它账户编号
    ,stl_way_cd -- 结算方式代码
    ,bank_bus_id -- 银行业务编号
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
    ,nvl(n.decl_id, o.decl_id) as decl_id -- 申报编号
    ,nvl(n.temp_decl_flow_id, o.temp_decl_flow_id) as temp_decl_flow_id -- 临时申报流水编号
    ,nvl(n.init_enty_id, o.init_enty_id) as init_enty_id -- 原始实体编号
    ,nvl(n.edit_id, o.edit_id) as edit_id -- 版本编号
    ,nvl(n.oper_type_cd, o.oper_type_cd) as oper_type_cd -- 操作类型代码
    ,nvl(n.modif_rs_descb, o.modif_rs_descb) as modif_rs_descb -- 变更原因描述
    ,nvl(n.decl_num, o.decl_num) as decl_num -- 申报号码
    ,nvl(n.remiter_type_cd, o.remiter_type_cd) as remiter_type_cd -- 汇款人类型代码
    ,nvl(n.indv_id_card_piece_no_code, o.indv_id_card_piece_no_code) as indv_id_card_piece_no_code -- 个人身份证件号码
    ,nvl(n.orgnz_id, o.orgnz_id) as orgnz_id -- 组织机构编号
    ,nvl(n.remiter_name, o.remiter_name) as remiter_name -- 汇款人名称
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 收款人名称
    ,nvl(n.remit_curr_cd, o.remit_curr_cd) as remit_curr_cd -- 汇款币种代码
    ,nvl(n.remit_amt, o.remit_amt) as remit_amt -- 汇款金额
    ,nvl(n.exch_rat, o.exch_rat) as exch_rat -- 汇率
    ,nvl(n.foreign_exch_pur_amt, o.foreign_exch_pur_amt) as foreign_exch_pur_amt -- 购汇金额
    ,nvl(n.cny_acct_id, o.cny_acct_id) as cny_acct_id -- 人民币账户编号
    ,nvl(n.spot_exch_amt, o.spot_exch_amt) as spot_exch_amt -- 现汇金额
    ,nvl(n.fx_acct_id, o.fx_acct_id) as fx_acct_id -- 外汇账户编号
    ,nvl(n.other_amt, o.other_amt) as other_amt -- 其他金额
    ,nvl(n.other_acct_id, o.other_acct_id) as other_acct_id -- 其它账户编号
    ,nvl(n.stl_way_cd, o.stl_way_cd) as stl_way_cd -- 结算方式代码
    ,nvl(n.bank_bus_id, o.bank_bus_id) as bank_bus_id -- 银行业务编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.decl_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.decl_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.decl_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_tm n
    full join (select * from ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.decl_id = n.decl_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.decl_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.decl_id is null
    )
    or (
        o.temp_decl_flow_id <> n.temp_decl_flow_id
        or o.init_enty_id <> n.init_enty_id
        or o.edit_id <> n.edit_id
        or o.oper_type_cd <> n.oper_type_cd
        or o.modif_rs_descb <> n.modif_rs_descb
        or o.decl_num <> n.decl_num
        or o.remiter_type_cd <> n.remiter_type_cd
        or o.indv_id_card_piece_no_code <> n.indv_id_card_piece_no_code
        or o.orgnz_id <> n.orgnz_id
        or o.remiter_name <> n.remiter_name
        or o.recver_name <> n.recver_name
        or o.remit_curr_cd <> n.remit_curr_cd
        or o.remit_amt <> n.remit_amt
        or o.exch_rat <> n.exch_rat
        or o.foreign_exch_pur_amt <> n.foreign_exch_pur_amt
        or o.cny_acct_id <> n.cny_acct_id
        or o.spot_exch_amt <> n.spot_exch_amt
        or o.fx_acct_id <> n.fx_acct_id
        or o.other_amt <> n.other_amt
        or o.other_acct_id <> n.other_acct_id
        or o.stl_way_cd <> n.stl_way_cd
        or o.bank_bus_id <> n.bank_bus_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,decl_id -- 申报编号
    ,temp_decl_flow_id -- 临时申报流水编号
    ,init_enty_id -- 原始实体编号
    ,edit_id -- 版本编号
    ,oper_type_cd -- 操作类型代码
    ,modif_rs_descb -- 变更原因描述
    ,decl_num -- 申报号码
    ,remiter_type_cd -- 汇款人类型代码
    ,indv_id_card_piece_no_code -- 个人身份证件号码
    ,orgnz_id -- 组织机构编号
    ,remiter_name -- 汇款人名称
    ,recver_name -- 收款人名称
    ,remit_curr_cd -- 汇款币种代码
    ,remit_amt -- 汇款金额
    ,exch_rat -- 汇率
    ,foreign_exch_pur_amt -- 购汇金额
    ,cny_acct_id -- 人民币账户编号
    ,spot_exch_amt -- 现汇金额
    ,fx_acct_id -- 外汇账户编号
    ,other_amt -- 其他金额
    ,other_acct_id -- 其它账户编号
    ,stl_way_cd -- 结算方式代码
    ,bank_bus_id -- 银行业务编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,decl_id -- 申报编号
    ,temp_decl_flow_id -- 临时申报流水编号
    ,init_enty_id -- 原始实体编号
    ,edit_id -- 版本编号
    ,oper_type_cd -- 操作类型代码
    ,modif_rs_descb -- 变更原因描述
    ,decl_num -- 申报号码
    ,remiter_type_cd -- 汇款人类型代码
    ,indv_id_card_piece_no_code -- 个人身份证件号码
    ,orgnz_id -- 组织机构编号
    ,remiter_name -- 汇款人名称
    ,recver_name -- 收款人名称
    ,remit_curr_cd -- 汇款币种代码
    ,remit_amt -- 汇款金额
    ,exch_rat -- 汇率
    ,foreign_exch_pur_amt -- 购汇金额
    ,cny_acct_id -- 人民币账户编号
    ,spot_exch_amt -- 现汇金额
    ,fx_acct_id -- 外汇账户编号
    ,other_amt -- 其他金额
    ,other_acct_id -- 其它账户编号
    ,stl_way_cd -- 结算方式代码
    ,bank_bus_id -- 银行业务编号
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
    ,o.decl_id -- 申报编号
    ,o.temp_decl_flow_id -- 临时申报流水编号
    ,o.init_enty_id -- 原始实体编号
    ,o.edit_id -- 版本编号
    ,o.oper_type_cd -- 操作类型代码
    ,o.modif_rs_descb -- 变更原因描述
    ,o.decl_num -- 申报号码
    ,o.remiter_type_cd -- 汇款人类型代码
    ,o.indv_id_card_piece_no_code -- 个人身份证件号码
    ,o.orgnz_id -- 组织机构编号
    ,o.remiter_name -- 汇款人名称
    ,o.recver_name -- 收款人名称
    ,o.remit_curr_cd -- 汇款币种代码
    ,o.remit_amt -- 汇款金额
    ,o.exch_rat -- 汇率
    ,o.foreign_exch_pur_amt -- 购汇金额
    ,o.cny_acct_id -- 人民币账户编号
    ,o.spot_exch_amt -- 现汇金额
    ,o.fx_acct_id -- 外汇账户编号
    ,o.other_amt -- 其他金额
    ,o.other_acct_id -- 其它账户编号
    ,o.stl_way_cd -- 结算方式代码
    ,o.bank_bus_id -- 银行业务编号
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
from ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_bk o
    left join ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.decl_id = n.decl_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.decl_id = d.decl_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_overs_remit_appl_base_info_h;
--alter table ${iml_schema}.agt_overs_remit_appl_base_info_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_overs_remit_appl_base_info_h') 
               and substr(subpartition_name,1,8)=upper('p_isbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_overs_remit_appl_base_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_overs_remit_appl_base_info_h modify partition p_isbsf1 
add subpartition p_isbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_overs_remit_appl_base_info_h exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_cl;
alter table ${iml_schema}.agt_overs_remit_appl_base_info_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_overs_remit_appl_base_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_op purge;
drop table ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_overs_remit_appl_base_info_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_overs_remit_appl_base_info_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
