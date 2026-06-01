/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_tran_bank_multilv_acct_h_tbpsf1
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
alter table ${iml_schema}.agt_tran_bank_multilv_acct_h add partition p_tbpsf1 values ('tbpsf1')(
        subpartition p_tbpsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_tbpsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_tran_bank_multilv_acct_h partition for ('tbpsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_tm purge;
drop table ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_op purge;
drop table ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_b_id -- 账簿编号
    ,level1_acct_b_id -- 一级账簿编号
    ,level2_acct_b_id -- 二级账簿编号
    ,level3_acct_b_id -- 三级账簿编号
    ,acct_b_name -- 账簿名称
    ,acct_b_lev -- 账簿级别
    ,bind_stl_acct_flg -- 绑定结算账户标志
    ,stl_card_acct_id -- 结算卡账户编号
    ,super_acct_b_id -- 上级账簿编号
    ,create_tm -- 创建时间
    ,acct_b_valid_flg -- 账簿有效标志
    ,acct_b_bal -- 账簿余额
    ,sign_parent_acct_id -- 签约母账户编号
    ,stl_card_status_cd -- 结算卡状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_tran_bank_multilv_acct_h partition for ('tbpsf1')
where 0=1
;

create table ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_tran_bank_multilv_acct_h partition for ('tbpsf1') where 0=1;

create table ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_tran_bank_multilv_acct_h partition for ('tbpsf1') where 0=1;

-- 3.1 get new data into table
-- tbps_cpr_aod_mulbook-1
insert into ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_b_id -- 账簿编号
    ,level1_acct_b_id -- 一级账簿编号
    ,level2_acct_b_id -- 二级账簿编号
    ,level3_acct_b_id -- 三级账簿编号
    ,acct_b_name -- 账簿名称
    ,acct_b_lev -- 账簿级别
    ,bind_stl_acct_flg -- 绑定结算账户标志
    ,stl_card_acct_id -- 结算卡账户编号
    ,super_acct_b_id -- 上级账簿编号
    ,create_tm -- 创建时间
    ,acct_b_valid_flg -- 账簿有效标志
    ,acct_b_bal -- 账簿余额
    ,sign_parent_acct_id -- 签约母账户编号
    ,stl_card_status_cd -- 结算卡状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    case when trim(p1.CAM_MOTHERACC) is null then ' '
    else '221009'||p1.CAM_CSTNO||p1.CAM_MOTHERACC end -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CAM_CSTNO -- 客户编号
    ,P1.CAM_BOOKNO -- 账簿编号
    ,P1.CAM_FIRSTBOOKNO -- 一级账簿编号
    ,P1.CAM_SECONDBOOKNO -- 二级账簿编号
    ,P1.CAM_THIRDBOOKNO -- 三级账簿编号
    ,P1.CAM_BOOKNAME -- 账簿名称
    ,P1.CAM_BOOKGRADE -- 账簿级别
    ,P1.CAM_IFBANDACC -- 绑定结算账户标志
    ,P1.CAM_ACCNO -- 结算卡账户编号
    ,P1.CAM_MOTHERBOOKNO -- 上级账簿编号
    ,${iml_schema}.dateformat_min(TRIM(P1.CAM_CREATEBOOKTIME)) -- 创建时间
    ,P1.CAM_BOOKSTATE -- 账簿有效标志
    ,nvl(regexp_substr(p1.CAM_AMOUNT, '[0-9.]+'),'0'） -- 账簿余额
    ,P1.CAM_MOTHERACC -- 签约母账户编号
    ,nvl(trim(P1.CAM_ACCNOSTATU),'-') -- 结算卡状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tbps_cpr_aod_mulbook' -- 源表名称
    ,'tbpsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tbps_cpr_aod_mulbook p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_b_id -- 账簿编号
    ,level1_acct_b_id -- 一级账簿编号
    ,level2_acct_b_id -- 二级账簿编号
    ,level3_acct_b_id -- 三级账簿编号
    ,acct_b_name -- 账簿名称
    ,acct_b_lev -- 账簿级别
    ,bind_stl_acct_flg -- 绑定结算账户标志
    ,stl_card_acct_id -- 结算卡账户编号
    ,super_acct_b_id -- 上级账簿编号
    ,create_tm -- 创建时间
    ,acct_b_valid_flg -- 账簿有效标志
    ,acct_b_bal -- 账簿余额
    ,sign_parent_acct_id -- 签约母账户编号
    ,stl_card_status_cd -- 结算卡状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_b_id -- 账簿编号
    ,level1_acct_b_id -- 一级账簿编号
    ,level2_acct_b_id -- 二级账簿编号
    ,level3_acct_b_id -- 三级账簿编号
    ,acct_b_name -- 账簿名称
    ,acct_b_lev -- 账簿级别
    ,bind_stl_acct_flg -- 绑定结算账户标志
    ,stl_card_acct_id -- 结算卡账户编号
    ,super_acct_b_id -- 上级账簿编号
    ,create_tm -- 创建时间
    ,acct_b_valid_flg -- 账簿有效标志
    ,acct_b_bal -- 账簿余额
    ,sign_parent_acct_id -- 签约母账户编号
    ,stl_card_status_cd -- 结算卡状态代码
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
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.acct_b_id, o.acct_b_id) as acct_b_id -- 账簿编号
    ,nvl(n.level1_acct_b_id, o.level1_acct_b_id) as level1_acct_b_id -- 一级账簿编号
    ,nvl(n.level2_acct_b_id, o.level2_acct_b_id) as level2_acct_b_id -- 二级账簿编号
    ,nvl(n.level3_acct_b_id, o.level3_acct_b_id) as level3_acct_b_id -- 三级账簿编号
    ,nvl(n.acct_b_name, o.acct_b_name) as acct_b_name -- 账簿名称
    ,nvl(n.acct_b_lev, o.acct_b_lev) as acct_b_lev -- 账簿级别
    ,nvl(n.bind_stl_acct_flg, o.bind_stl_acct_flg) as bind_stl_acct_flg -- 绑定结算账户标志
    ,nvl(n.stl_card_acct_id, o.stl_card_acct_id) as stl_card_acct_id -- 结算卡账户编号
    ,nvl(n.super_acct_b_id, o.super_acct_b_id) as super_acct_b_id -- 上级账簿编号
    ,nvl(n.create_tm, o.create_tm) as create_tm -- 创建时间
    ,nvl(n.acct_b_valid_flg, o.acct_b_valid_flg) as acct_b_valid_flg -- 账簿有效标志
    ,nvl(n.acct_b_bal, o.acct_b_bal) as acct_b_bal -- 账簿余额
    ,nvl(n.sign_parent_acct_id, o.sign_parent_acct_id) as sign_parent_acct_id -- 签约母账户编号
    ,nvl(n.stl_card_status_cd, o.stl_card_status_cd) as stl_card_status_cd -- 结算卡状态代码
    ,case when
            n.lp_id is null
            and n.cust_id is null
            and n.acct_b_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.lp_id is null
            and n.cust_id is null
            and n.acct_b_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.lp_id is null
            and n.cust_id is null
            and n.acct_b_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_tm n
    full join (select * from ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.lp_id = n.lp_id
            and o.cust_id = n.cust_id
            and o.acct_b_id = n.acct_b_id
where (
        o.lp_id is null
        and o.cust_id is null
        and o.acct_b_id is null
    )
    or (
        n.lp_id is null
        and n.cust_id is null
        and n.acct_b_id is null
    )
    or (
        o.agt_id <> n.agt_id
        or o.level1_acct_b_id <> n.level1_acct_b_id
        or o.level2_acct_b_id <> n.level2_acct_b_id
        or o.level3_acct_b_id <> n.level3_acct_b_id
        or o.acct_b_name <> n.acct_b_name
        or o.acct_b_lev <> n.acct_b_lev
        or o.bind_stl_acct_flg <> n.bind_stl_acct_flg
        or o.stl_card_acct_id <> n.stl_card_acct_id
        or o.super_acct_b_id <> n.super_acct_b_id
        or o.create_tm <> n.create_tm
        or o.acct_b_valid_flg <> n.acct_b_valid_flg
        or o.acct_b_bal <> n.acct_b_bal
        or o.sign_parent_acct_id <> n.sign_parent_acct_id
        or o.stl_card_status_cd <> n.stl_card_status_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_b_id -- 账簿编号
    ,level1_acct_b_id -- 一级账簿编号
    ,level2_acct_b_id -- 二级账簿编号
    ,level3_acct_b_id -- 三级账簿编号
    ,acct_b_name -- 账簿名称
    ,acct_b_lev -- 账簿级别
    ,bind_stl_acct_flg -- 绑定结算账户标志
    ,stl_card_acct_id -- 结算卡账户编号
    ,super_acct_b_id -- 上级账簿编号
    ,create_tm -- 创建时间
    ,acct_b_valid_flg -- 账簿有效标志
    ,acct_b_bal -- 账簿余额
    ,sign_parent_acct_id -- 签约母账户编号
    ,stl_card_status_cd -- 结算卡状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_b_id -- 账簿编号
    ,level1_acct_b_id -- 一级账簿编号
    ,level2_acct_b_id -- 二级账簿编号
    ,level3_acct_b_id -- 三级账簿编号
    ,acct_b_name -- 账簿名称
    ,acct_b_lev -- 账簿级别
    ,bind_stl_acct_flg -- 绑定结算账户标志
    ,stl_card_acct_id -- 结算卡账户编号
    ,super_acct_b_id -- 上级账簿编号
    ,create_tm -- 创建时间
    ,acct_b_valid_flg -- 账簿有效标志
    ,acct_b_bal -- 账簿余额
    ,sign_parent_acct_id -- 签约母账户编号
    ,stl_card_status_cd -- 结算卡状态代码
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
    ,o.cust_id -- 客户编号
    ,o.acct_b_id -- 账簿编号
    ,o.level1_acct_b_id -- 一级账簿编号
    ,o.level2_acct_b_id -- 二级账簿编号
    ,o.level3_acct_b_id -- 三级账簿编号
    ,o.acct_b_name -- 账簿名称
    ,o.acct_b_lev -- 账簿级别
    ,o.bind_stl_acct_flg -- 绑定结算账户标志
    ,o.stl_card_acct_id -- 结算卡账户编号
    ,o.super_acct_b_id -- 上级账簿编号
    ,o.create_tm -- 创建时间
    ,o.acct_b_valid_flg -- 账簿有效标志
    ,o.acct_b_bal -- 账簿余额
    ,o.sign_parent_acct_id -- 签约母账户编号
    ,o.stl_card_status_cd -- 结算卡状态代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_bk o
    left join ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_op n
        on
            o.lp_id = n.lp_id
            and o.cust_id = n.cust_id
            and o.acct_b_id = n.acct_b_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_cl d
        on
            o.lp_id = d.lp_id
            and o.cust_id = d.cust_id
            and o.acct_b_id = d.acct_b_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_tran_bank_multilv_acct_h;
alter table ${iml_schema}.agt_tran_bank_multilv_acct_h truncate partition for ('tbpsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_tran_bank_multilv_acct_h exchange subpartition p_tbpsf1_19000101 with table ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_cl;
alter table ${iml_schema}.agt_tran_bank_multilv_acct_h exchange subpartition p_tbpsf1_20991231 with table ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_tran_bank_multilv_acct_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_tm purge;
drop table ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_op purge;
drop table ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_tran_bank_multilv_acct_h_tbpsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_tran_bank_multilv_acct_h', partname => 'p_tbpsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
