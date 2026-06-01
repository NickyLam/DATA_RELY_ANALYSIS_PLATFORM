/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_stay_ruin_card_info
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
create table ${iol_schema}.ncbs_tb_stay_ruin_card_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_stay_ruin_card_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_stay_ruin_card_info_op purge;
drop table ${iol_schema}.ncbs_tb_stay_ruin_card_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_stay_ruin_card_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_stay_ruin_card_info where 0=1;

create table ${iol_schema}.ncbs_tb_stay_ruin_card_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_stay_ruin_card_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_stay_ruin_card_info_cl(
            card_no -- 卡号
            ,client_name -- 客户名称
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,remark -- 备注
            ,atm_no -- atm机编号
            ,company -- 法人
            ,draw_man -- 领取人
            ,other_bank_flag -- 他行标记
            ,capture_date -- 收缴日期
            ,ruin_date -- 销毁日期
            ,tran_timestamp -- 交易时间戳
            ,untread_date -- 领取日期
            ,belong_user_id -- 所属柜员
            ,capture_branch -- 收缴机构
            ,capture_user_id -- 收缴柜员
            ,open_branch -- 开立机构
            ,ruin_branch -- 销毁机构
            ,ruin_user_id -- 销毁柜员
            ,untread_user_id -- 领取交易柜员
            ,stay_card_type -- 吞没卡种类
            ,stay_card_status -- 吞没卡状态
            ,belong_branch -- 归属机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_stay_ruin_card_info_op(
            card_no -- 卡号
            ,client_name -- 客户名称
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,remark -- 备注
            ,atm_no -- atm机编号
            ,company -- 法人
            ,draw_man -- 领取人
            ,other_bank_flag -- 他行标记
            ,capture_date -- 收缴日期
            ,ruin_date -- 销毁日期
            ,tran_timestamp -- 交易时间戳
            ,untread_date -- 领取日期
            ,belong_user_id -- 所属柜员
            ,capture_branch -- 收缴机构
            ,capture_user_id -- 收缴柜员
            ,open_branch -- 开立机构
            ,ruin_branch -- 销毁机构
            ,ruin_user_id -- 销毁柜员
            ,untread_user_id -- 领取交易柜员
            ,stay_card_type -- 吞没卡种类
            ,stay_card_status -- 吞没卡状态
            ,belong_branch -- 归属机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.client_name, o.client_name) as client_name -- 客户名称
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.atm_no, o.atm_no) as atm_no -- atm机编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.draw_man, o.draw_man) as draw_man -- 领取人
    ,nvl(n.other_bank_flag, o.other_bank_flag) as other_bank_flag -- 他行标记
    ,nvl(n.capture_date, o.capture_date) as capture_date -- 收缴日期
    ,nvl(n.ruin_date, o.ruin_date) as ruin_date -- 销毁日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.untread_date, o.untread_date) as untread_date -- 领取日期
    ,nvl(n.belong_user_id, o.belong_user_id) as belong_user_id -- 所属柜员
    ,nvl(n.capture_branch, o.capture_branch) as capture_branch -- 收缴机构
    ,nvl(n.capture_user_id, o.capture_user_id) as capture_user_id -- 收缴柜员
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 开立机构
    ,nvl(n.ruin_branch, o.ruin_branch) as ruin_branch -- 销毁机构
    ,nvl(n.ruin_user_id, o.ruin_user_id) as ruin_user_id -- 销毁柜员
    ,nvl(n.untread_user_id, o.untread_user_id) as untread_user_id -- 领取交易柜员
    ,nvl(n.stay_card_type, o.stay_card_type) as stay_card_type -- 吞没卡种类
    ,nvl(n.stay_card_status, o.stay_card_status) as stay_card_status -- 吞没卡状态
    ,nvl(n.belong_branch, o.belong_branch) as belong_branch -- 归属机构
    ,case when
            n.card_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.card_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.card_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_stay_ruin_card_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_stay_ruin_card_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.card_no = n.card_no
where (
        o.card_no is null
    )
    or (
        n.card_no is null
    )
    or (
        o.client_name <> n.client_name
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.remark <> n.remark
        or o.atm_no <> n.atm_no
        or o.company <> n.company
        or o.draw_man <> n.draw_man
        or o.other_bank_flag <> n.other_bank_flag
        or o.capture_date <> n.capture_date
        or o.ruin_date <> n.ruin_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.untread_date <> n.untread_date
        or o.belong_user_id <> n.belong_user_id
        or o.capture_branch <> n.capture_branch
        or o.capture_user_id <> n.capture_user_id
        or o.open_branch <> n.open_branch
        or o.ruin_branch <> n.ruin_branch
        or o.ruin_user_id <> n.ruin_user_id
        or o.untread_user_id <> n.untread_user_id
        or o.stay_card_type <> n.stay_card_type
        or o.stay_card_status <> n.stay_card_status
        or o.belong_branch <> n.belong_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_stay_ruin_card_info_cl(
            card_no -- 卡号
            ,client_name -- 客户名称
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,remark -- 备注
            ,atm_no -- atm机编号
            ,company -- 法人
            ,draw_man -- 领取人
            ,other_bank_flag -- 他行标记
            ,capture_date -- 收缴日期
            ,ruin_date -- 销毁日期
            ,tran_timestamp -- 交易时间戳
            ,untread_date -- 领取日期
            ,belong_user_id -- 所属柜员
            ,capture_branch -- 收缴机构
            ,capture_user_id -- 收缴柜员
            ,open_branch -- 开立机构
            ,ruin_branch -- 销毁机构
            ,ruin_user_id -- 销毁柜员
            ,untread_user_id -- 领取交易柜员
            ,stay_card_type -- 吞没卡种类
            ,stay_card_status -- 吞没卡状态
            ,belong_branch -- 归属机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_stay_ruin_card_info_op(
            card_no -- 卡号
            ,client_name -- 客户名称
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,remark -- 备注
            ,atm_no -- atm机编号
            ,company -- 法人
            ,draw_man -- 领取人
            ,other_bank_flag -- 他行标记
            ,capture_date -- 收缴日期
            ,ruin_date -- 销毁日期
            ,tran_timestamp -- 交易时间戳
            ,untread_date -- 领取日期
            ,belong_user_id -- 所属柜员
            ,capture_branch -- 收缴机构
            ,capture_user_id -- 收缴柜员
            ,open_branch -- 开立机构
            ,ruin_branch -- 销毁机构
            ,ruin_user_id -- 销毁柜员
            ,untread_user_id -- 领取交易柜员
            ,stay_card_type -- 吞没卡种类
            ,stay_card_status -- 吞没卡状态
            ,belong_branch -- 归属机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.card_no -- 卡号
    ,o.client_name -- 客户名称
    ,o.document_id -- 证件号码
    ,o.document_type -- 客户证件类型
    ,o.remark -- 备注
    ,o.atm_no -- atm机编号
    ,o.company -- 法人
    ,o.draw_man -- 领取人
    ,o.other_bank_flag -- 他行标记
    ,o.capture_date -- 收缴日期
    ,o.ruin_date -- 销毁日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.untread_date -- 领取日期
    ,o.belong_user_id -- 所属柜员
    ,o.capture_branch -- 收缴机构
    ,o.capture_user_id -- 收缴柜员
    ,o.open_branch -- 开立机构
    ,o.ruin_branch -- 销毁机构
    ,o.ruin_user_id -- 销毁柜员
    ,o.untread_user_id -- 领取交易柜员
    ,o.stay_card_type -- 吞没卡种类
    ,o.stay_card_status -- 吞没卡状态
    ,o.belong_branch -- 归属机构
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
from ${iol_schema}.ncbs_tb_stay_ruin_card_info_bk o
    left join ${iol_schema}.ncbs_tb_stay_ruin_card_info_op n
        on
            o.card_no = n.card_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_stay_ruin_card_info_cl d
        on
            o.card_no = d.card_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_stay_ruin_card_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_stay_ruin_card_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_stay_ruin_card_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_stay_ruin_card_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_stay_ruin_card_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_stay_ruin_card_info_cl;
alter table ${iol_schema}.ncbs_tb_stay_ruin_card_info exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_stay_ruin_card_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_stay_ruin_card_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_stay_ruin_card_info_op purge;
drop table ${iol_schema}.ncbs_tb_stay_ruin_card_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_stay_ruin_card_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_stay_ruin_card_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
