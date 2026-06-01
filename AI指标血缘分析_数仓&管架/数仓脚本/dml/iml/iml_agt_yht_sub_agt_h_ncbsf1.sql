/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_yht_sub_agt_h_ncbsf1
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
alter table ${iml_schema}.agt_yht_sub_agt_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_yht_sub_agt_h partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,main_agt_id -- 主协议编号
    ,sign_agt_id -- 签约协议编号
    ,acct_id -- 账户编号
    ,super_acct_id -- 上级账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,resv_acct_name -- 备用账户名称
    ,vtual_acct_flg -- 虚户标志
    ,subor_acct_max_seq_num -- 下级账户最大序号
    ,self_own_cap_sub_acct_flg -- 自有资金子账户标志
    ,deduct_int_flg -- 扣划利息标志
    ,stl_mode_cd -- 结算模式代码
    ,yht_prod_id -- 一户通产品编号
    ,yht_acct_type_cd -- 一户通账户类型代码
    ,yht_acct_hibchy -- 一户通账户层级
    ,yht_main_acct_type_cd -- 一户通主账户类型代码
    ,yht_acct_stru_mode -- 一户通账户结构模式代码
    ,od_flg -- 透支标志
    ,chn_id -- 渠道编号
    ,cust_id -- 客户编号
    ,not_tran_data_flg -- 未移植数据标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_yht_sub_agt_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_yht_sub_agt_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_yht_sub_agt_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_agreement_yht-1
insert into ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,main_agt_id -- 主协议编号
    ,sign_agt_id -- 签约协议编号
    ,acct_id -- 账户编号
    ,super_acct_id -- 上级账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,resv_acct_name -- 备用账户名称
    ,vtual_acct_flg -- 虚户标志
    ,subor_acct_max_seq_num -- 下级账户最大序号
    ,self_own_cap_sub_acct_flg -- 自有资金子账户标志
    ,deduct_int_flg -- 扣划利息标志
    ,stl_mode_cd -- 结算模式代码
    ,yht_prod_id -- 一户通产品编号
    ,yht_acct_type_cd -- 一户通账户类型代码
    ,yht_acct_hibchy -- 一户通账户层级
    ,yht_main_acct_type_cd -- 一户通主账户类型代码
    ,yht_acct_stru_mode -- 一户通账户结构模式代码
    ,od_flg -- 透支标志
    ,chn_id -- 渠道编号
    ,cust_id -- 客户编号
    ,not_tran_data_flg -- 未移植数据标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300003'||P1.AGREEMENT_ID -- 协议编号
    ,P1.AGREEMENT_ID -- 存款协议编号
    ,'9999' -- 法人编号
    ,P1.MAIN_AGREEMENT_ID -- 主协议编号
    ,P1.AGREEMENT_STATUS -- 签约协议编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.PARENT_INTERNAL_KEY -- 上级账户编号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.ACCT_CCY -- 币种代码
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.ALT_ACCT_NAME -- 备用账户名称
    ,DECODE(P1.ACCT_REAL_FLAG,'Y','1','N','0') -- 虚户标志
    ,P1.NEXT_MAX_SEQ_NO -- 下级账户最大序号
    ,DECODE(P1.SELF_FLAG,'Y','1','N','0') -- 自有资金子账户标志
    ,DECODE(P1.INT_FLAG,'Y','1','N','0') -- 扣划利息标志
    ,P1.SETTLE_IND -- 结算模式代码
    ,P1.YHT_PROD_TYPE -- 一户通产品编号
    ,P1.YHT_ACCT_FLAG -- 一户通账户类型代码
    ,P1.YHT_ACCT_LEVEL -- 一户通账户层级
    ,P1.YHT_ACCT_MAIN_FLAG -- 一户通主账户类型代码
    ,P1.YHT_ACCT_ORG_SCHEMA -- 一户通账户结构模式代码
    ,DECODE(P1.ISS_OD_FLAG,'Y','1','N','0') -- 透支标志
    ,P1.SOURCE_TYPE -- 渠道编号
    ,P1.CLIENT_NO -- 客户编号
    ,DECODE(P1.NON_TRANSPLANT_FLAG,'Y','1','N','0') -- 未移植数据标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_agreement_yht' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_agreement_yht p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,dep_agt_id
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
        into ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,main_agt_id -- 主协议编号
    ,sign_agt_id -- 签约协议编号
    ,acct_id -- 账户编号
    ,super_acct_id -- 上级账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,resv_acct_name -- 备用账户名称
    ,vtual_acct_flg -- 虚户标志
    ,subor_acct_max_seq_num -- 下级账户最大序号
    ,self_own_cap_sub_acct_flg -- 自有资金子账户标志
    ,deduct_int_flg -- 扣划利息标志
    ,stl_mode_cd -- 结算模式代码
    ,yht_prod_id -- 一户通产品编号
    ,yht_acct_type_cd -- 一户通账户类型代码
    ,yht_acct_hibchy -- 一户通账户层级
    ,yht_main_acct_type_cd -- 一户通主账户类型代码
    ,yht_acct_stru_mode -- 一户通账户结构模式代码
    ,od_flg -- 透支标志
    ,chn_id -- 渠道编号
    ,cust_id -- 客户编号
    ,not_tran_data_flg -- 未移植数据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,main_agt_id -- 主协议编号
    ,sign_agt_id -- 签约协议编号
    ,acct_id -- 账户编号
    ,super_acct_id -- 上级账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,resv_acct_name -- 备用账户名称
    ,vtual_acct_flg -- 虚户标志
    ,subor_acct_max_seq_num -- 下级账户最大序号
    ,self_own_cap_sub_acct_flg -- 自有资金子账户标志
    ,deduct_int_flg -- 扣划利息标志
    ,stl_mode_cd -- 结算模式代码
    ,yht_prod_id -- 一户通产品编号
    ,yht_acct_type_cd -- 一户通账户类型代码
    ,yht_acct_hibchy -- 一户通账户层级
    ,yht_main_acct_type_cd -- 一户通主账户类型代码
    ,yht_acct_stru_mode -- 一户通账户结构模式代码
    ,od_flg -- 透支标志
    ,chn_id -- 渠道编号
    ,cust_id -- 客户编号
    ,not_tran_data_flg -- 未移植数据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.dep_agt_id, o.dep_agt_id) as dep_agt_id -- 存款协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.main_agt_id, o.main_agt_id) as main_agt_id -- 主协议编号
    ,nvl(n.sign_agt_id, o.sign_agt_id) as sign_agt_id -- 签约协议编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.super_acct_id, o.super_acct_id) as super_acct_id -- 上级账户编号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.resv_acct_name, o.resv_acct_name) as resv_acct_name -- 备用账户名称
    ,nvl(n.vtual_acct_flg, o.vtual_acct_flg) as vtual_acct_flg -- 虚户标志
    ,nvl(n.subor_acct_max_seq_num, o.subor_acct_max_seq_num) as subor_acct_max_seq_num -- 下级账户最大序号
    ,nvl(n.self_own_cap_sub_acct_flg, o.self_own_cap_sub_acct_flg) as self_own_cap_sub_acct_flg -- 自有资金子账户标志
    ,nvl(n.deduct_int_flg, o.deduct_int_flg) as deduct_int_flg -- 扣划利息标志
    ,nvl(n.stl_mode_cd, o.stl_mode_cd) as stl_mode_cd -- 结算模式代码
    ,nvl(n.yht_prod_id, o.yht_prod_id) as yht_prod_id -- 一户通产品编号
    ,nvl(n.yht_acct_type_cd, o.yht_acct_type_cd) as yht_acct_type_cd -- 一户通账户类型代码
    ,nvl(n.yht_acct_hibchy, o.yht_acct_hibchy) as yht_acct_hibchy -- 一户通账户层级
    ,nvl(n.yht_main_acct_type_cd, o.yht_main_acct_type_cd) as yht_main_acct_type_cd -- 一户通主账户类型代码
    ,nvl(n.yht_acct_stru_mode, o.yht_acct_stru_mode) as yht_acct_stru_mode -- 一户通账户结构模式代码
    ,nvl(n.od_flg, o.od_flg) as od_flg -- 透支标志
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.not_tran_data_flg, o.not_tran_data_flg) as not_tran_data_flg -- 未移植数据标志
    ,case when
            n.agt_id is null
            and n.dep_agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.dep_agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.dep_agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.dep_agt_id = n.dep_agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.dep_agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.dep_agt_id is null
        and n.lp_id is null
    )
    or (
        o.main_agt_id <> n.main_agt_id
        or o.sign_agt_id <> n.sign_agt_id
        or o.acct_id <> n.acct_id
        or o.super_acct_id <> n.super_acct_id
        or o.cust_acct_num <> n.cust_acct_num
        or o.prod_id <> n.prod_id
        or o.curr_cd <> n.curr_cd
        or o.sub_acct_num <> n.sub_acct_num
        or o.acct_name <> n.acct_name
        or o.resv_acct_name <> n.resv_acct_name
        or o.vtual_acct_flg <> n.vtual_acct_flg
        or o.subor_acct_max_seq_num <> n.subor_acct_max_seq_num
        or o.self_own_cap_sub_acct_flg <> n.self_own_cap_sub_acct_flg
        or o.deduct_int_flg <> n.deduct_int_flg
        or o.stl_mode_cd <> n.stl_mode_cd
        or o.yht_prod_id <> n.yht_prod_id
        or o.yht_acct_type_cd <> n.yht_acct_type_cd
        or o.yht_acct_hibchy <> n.yht_acct_hibchy
        or o.yht_main_acct_type_cd <> n.yht_main_acct_type_cd
        or o.yht_acct_stru_mode <> n.yht_acct_stru_mode
        or o.od_flg <> n.od_flg
        or o.chn_id <> n.chn_id
        or o.cust_id <> n.cust_id
        or o.not_tran_data_flg <> n.not_tran_data_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,main_agt_id -- 主协议编号
    ,sign_agt_id -- 签约协议编号
    ,acct_id -- 账户编号
    ,super_acct_id -- 上级账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,resv_acct_name -- 备用账户名称
    ,vtual_acct_flg -- 虚户标志
    ,subor_acct_max_seq_num -- 下级账户最大序号
    ,self_own_cap_sub_acct_flg -- 自有资金子账户标志
    ,deduct_int_flg -- 扣划利息标志
    ,stl_mode_cd -- 结算模式代码
    ,yht_prod_id -- 一户通产品编号
    ,yht_acct_type_cd -- 一户通账户类型代码
    ,yht_acct_hibchy -- 一户通账户层级
    ,yht_main_acct_type_cd -- 一户通主账户类型代码
    ,yht_acct_stru_mode -- 一户通账户结构模式代码
    ,od_flg -- 透支标志
    ,chn_id -- 渠道编号
    ,cust_id -- 客户编号
    ,not_tran_data_flg -- 未移植数据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,main_agt_id -- 主协议编号
    ,sign_agt_id -- 签约协议编号
    ,acct_id -- 账户编号
    ,super_acct_id -- 上级账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,resv_acct_name -- 备用账户名称
    ,vtual_acct_flg -- 虚户标志
    ,subor_acct_max_seq_num -- 下级账户最大序号
    ,self_own_cap_sub_acct_flg -- 自有资金子账户标志
    ,deduct_int_flg -- 扣划利息标志
    ,stl_mode_cd -- 结算模式代码
    ,yht_prod_id -- 一户通产品编号
    ,yht_acct_type_cd -- 一户通账户类型代码
    ,yht_acct_hibchy -- 一户通账户层级
    ,yht_main_acct_type_cd -- 一户通主账户类型代码
    ,yht_acct_stru_mode -- 一户通账户结构模式代码
    ,od_flg -- 透支标志
    ,chn_id -- 渠道编号
    ,cust_id -- 客户编号
    ,not_tran_data_flg -- 未移植数据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.dep_agt_id -- 存款协议编号
    ,o.lp_id -- 法人编号
    ,o.main_agt_id -- 主协议编号
    ,o.sign_agt_id -- 签约协议编号
    ,o.acct_id -- 账户编号
    ,o.super_acct_id -- 上级账户编号
    ,o.cust_acct_num -- 客户账号
    ,o.prod_id -- 产品编号
    ,o.curr_cd -- 币种代码
    ,o.sub_acct_num -- 子账号
    ,o.acct_name -- 账户名称
    ,o.resv_acct_name -- 备用账户名称
    ,o.vtual_acct_flg -- 虚户标志
    ,o.subor_acct_max_seq_num -- 下级账户最大序号
    ,o.self_own_cap_sub_acct_flg -- 自有资金子账户标志
    ,o.deduct_int_flg -- 扣划利息标志
    ,o.stl_mode_cd -- 结算模式代码
    ,o.yht_prod_id -- 一户通产品编号
    ,o.yht_acct_type_cd -- 一户通账户类型代码
    ,o.yht_acct_hibchy -- 一户通账户层级
    ,o.yht_main_acct_type_cd -- 一户通主账户类型代码
    ,o.yht_acct_stru_mode -- 一户通账户结构模式代码
    ,o.od_flg -- 透支标志
    ,o.chn_id -- 渠道编号
    ,o.cust_id -- 客户编号
    ,o.not_tran_data_flg -- 未移植数据标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_bk o
    left join ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.dep_agt_id = n.dep_agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.dep_agt_id = d.dep_agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_yht_sub_agt_h;
alter table ${iml_schema}.agt_yht_sub_agt_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_yht_sub_agt_h exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_cl;
alter table ${iml_schema}.agt_yht_sub_agt_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_yht_sub_agt_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_yht_sub_agt_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_yht_sub_agt_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
