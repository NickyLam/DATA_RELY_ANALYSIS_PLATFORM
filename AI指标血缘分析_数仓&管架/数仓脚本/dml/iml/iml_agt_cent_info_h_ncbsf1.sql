/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cent_info_h_ncbsf1
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
alter table ${iml_schema}.agt_cent_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_cent_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cent_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_cent_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cent_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cent_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cent_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,tran_ref_no -- 交易参考号
    ,ova_flow_num -- 全局流水号
    ,sys_sub_flow_num -- 系统子流水号
    ,evt_cate_cd -- 事件类别代码
    ,cent_type_cd -- 分位处理类型代码
    ,cent -- 分位金额
    ,curr_cd -- 币种代码
    ,amt_type_cd -- 金额类型代码
    ,tran_code -- 交易码
    ,tran_dt -- 交易日期
    ,tran_status_cd -- 交易状态代码
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,revs_flg -- 冲正标志
    ,revs_flow_num -- 冲正流水号
    ,revs_tran_code -- 冲正交易码
    ,revs_tran_dt -- 冲正交易日期
    ,revs_teller_id -- 冲正柜员编号
    ,erase_acct_flg -- 冲抹标志
    ,revs_rs -- 冲正原因
    ,tran_tm -- 交易时间
    ,clos_acct_flg -- 销户标志
    ,init_chn_flow_num -- 原渠道流水号
    ,init_chn_sub_flow_num -- 原渠道子流水号
    ,init_tran_amt -- 原交易金额
    ,init_tran_dt -- 原交易日期
    ,main_module_cd -- 主模块代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cent_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_cent_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cent_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_cent_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cent_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_cent_reg-1
insert into ${iml_schema}.agt_cent_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,tran_ref_no -- 交易参考号
    ,ova_flow_num -- 全局流水号
    ,sys_sub_flow_num -- 系统子流水号
    ,evt_cate_cd -- 事件类别代码
    ,cent_type_cd -- 分位处理类型代码
    ,cent -- 分位金额
    ,curr_cd -- 币种代码
    ,amt_type_cd -- 金额类型代码
    ,tran_code -- 交易码
    ,tran_dt -- 交易日期
    ,tran_status_cd -- 交易状态代码
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,revs_flg -- 冲正标志
    ,revs_flow_num -- 冲正流水号
    ,revs_tran_code -- 冲正交易码
    ,revs_tran_dt -- 冲正交易日期
    ,revs_teller_id -- 冲正柜员编号
    ,erase_acct_flg -- 冲抹标志
    ,revs_rs -- 冲正原因
    ,tran_tm -- 交易时间
    ,clos_acct_flg -- 销户标志
    ,init_chn_flow_num -- 原渠道流水号
    ,init_chn_sub_flow_num -- 原渠道子流水号
    ,init_tran_amt -- 原交易金额
    ,init_tran_dt -- 原交易日期
    ,main_module_cd -- 主模块代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300058'||P1.SEQ_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SEQ_NO -- 序号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.REFERENCE -- 交易参考号
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,P1.SUB_SEQ_NO -- 系统子流水号
    ,nvl(trim(P1.EVENT_TYPE),'-') -- 事件类别代码
    ,nvl(trim(P1.CENT_DEAL_TYPE),'-') -- 分位处理类型代码
    ,P1.CENT_AMT -- 分位金额
    ,nvl(trim(P1.CCY),'-') -- 币种代码
    ,nvl(trim(P1.AMT_TYPE),'-') -- 金额类型代码
    ,P1.TRAN_TYPE -- 交易码
    ,P1.TRAN_DATE -- 交易日期
    ,nvl(trim(P1.STATUS),'-') -- 交易状态代码
    ,P1.USER_ID -- 交易柜员编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,decode(P1.REVERSAL_FLAG,'Y','1','N','0',' ','-',P1.REVERSAL_FLAG) -- 冲正标志
    ,P1.REVERSAL_SEQ_NO -- 冲正流水号
    ,P1.REVERSAL_TRAN_TYPE -- 冲正交易码
    ,P1.REVERSAL_TRAN_DATE -- 冲正交易日期
    ,P1.REVERSAL_USER_ID -- 冲正柜员编号
    ,decode(P1.WIPE_ACCOUNT,'Y','1','N','0',' ','-',P1.WIPE_ACCOUNT) -- 冲抹标志
    ,P1.REVERSAL_REASON -- 冲正原因
    ,${iml_schema}.timeformat_max2(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,nvl(trim(P1.CLOSE_ACCT_IND),'-') -- 销户标志
    ,P1.ORIG_CHANNEL_SEQ_NO -- 原渠道流水号
    ,P1.ORIG_SUB_SEQ_NO -- 原渠道子流水号
    ,P1.ORIG_TRAN_AMT -- 原交易金额
    ,P1.ORIG_TRAN_DATE -- 原交易日期
    ,nvl(trim(P1.MAIN_SOURCE_MODULE),'-') -- 主模块代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_cent_reg' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_cent_reg p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_cent_info_h_ncbsf1_tm 
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
        into ${iml_schema}.agt_cent_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,tran_ref_no -- 交易参考号
    ,ova_flow_num -- 全局流水号
    ,sys_sub_flow_num -- 系统子流水号
    ,evt_cate_cd -- 事件类别代码
    ,cent_type_cd -- 分位处理类型代码
    ,cent -- 分位金额
    ,curr_cd -- 币种代码
    ,amt_type_cd -- 金额类型代码
    ,tran_code -- 交易码
    ,tran_dt -- 交易日期
    ,tran_status_cd -- 交易状态代码
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,revs_flg -- 冲正标志
    ,revs_flow_num -- 冲正流水号
    ,revs_tran_code -- 冲正交易码
    ,revs_tran_dt -- 冲正交易日期
    ,revs_teller_id -- 冲正柜员编号
    ,erase_acct_flg -- 冲抹标志
    ,revs_rs -- 冲正原因
    ,tran_tm -- 交易时间
    ,clos_acct_flg -- 销户标志
    ,init_chn_flow_num -- 原渠道流水号
    ,init_chn_sub_flow_num -- 原渠道子流水号
    ,init_tran_amt -- 原交易金额
    ,init_tran_dt -- 原交易日期
    ,main_module_cd -- 主模块代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cent_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,tran_ref_no -- 交易参考号
    ,ova_flow_num -- 全局流水号
    ,sys_sub_flow_num -- 系统子流水号
    ,evt_cate_cd -- 事件类别代码
    ,cent_type_cd -- 分位处理类型代码
    ,cent -- 分位金额
    ,curr_cd -- 币种代码
    ,amt_type_cd -- 金额类型代码
    ,tran_code -- 交易码
    ,tran_dt -- 交易日期
    ,tran_status_cd -- 交易状态代码
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,revs_flg -- 冲正标志
    ,revs_flow_num -- 冲正流水号
    ,revs_tran_code -- 冲正交易码
    ,revs_tran_dt -- 冲正交易日期
    ,revs_teller_id -- 冲正柜员编号
    ,erase_acct_flg -- 冲抹标志
    ,revs_rs -- 冲正原因
    ,tran_tm -- 交易时间
    ,clos_acct_flg -- 销户标志
    ,init_chn_flow_num -- 原渠道流水号
    ,init_chn_sub_flow_num -- 原渠道子流水号
    ,init_tran_amt -- 原交易金额
    ,init_tran_dt -- 原交易日期
    ,main_module_cd -- 主模块代码
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
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.ova_flow_num, o.ova_flow_num) as ova_flow_num -- 全局流水号
    ,nvl(n.sys_sub_flow_num, o.sys_sub_flow_num) as sys_sub_flow_num -- 系统子流水号
    ,nvl(n.evt_cate_cd, o.evt_cate_cd) as evt_cate_cd -- 事件类别代码
    ,nvl(n.cent_type_cd, o.cent_type_cd) as cent_type_cd -- 分位处理类型代码
    ,nvl(n.cent, o.cent) as cent -- 分位金额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.amt_type_cd, o.amt_type_cd) as amt_type_cd -- 金额类型代码
    ,nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.revs_flg, o.revs_flg) as revs_flg -- 冲正标志
    ,nvl(n.revs_flow_num, o.revs_flow_num) as revs_flow_num -- 冲正流水号
    ,nvl(n.revs_tran_code, o.revs_tran_code) as revs_tran_code -- 冲正交易码
    ,nvl(n.revs_tran_dt, o.revs_tran_dt) as revs_tran_dt -- 冲正交易日期
    ,nvl(n.revs_teller_id, o.revs_teller_id) as revs_teller_id -- 冲正柜员编号
    ,nvl(n.erase_acct_flg, o.erase_acct_flg) as erase_acct_flg -- 冲抹标志
    ,nvl(n.revs_rs, o.revs_rs) as revs_rs -- 冲正原因
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.clos_acct_flg, o.clos_acct_flg) as clos_acct_flg -- 销户标志
    ,nvl(n.init_chn_flow_num, o.init_chn_flow_num) as init_chn_flow_num -- 原渠道流水号
    ,nvl(n.init_chn_sub_flow_num, o.init_chn_sub_flow_num) as init_chn_sub_flow_num -- 原渠道子流水号
    ,nvl(n.init_tran_amt, o.init_tran_amt) as init_tran_amt -- 原交易金额
    ,nvl(n.init_tran_dt, o.init_tran_dt) as init_tran_dt -- 原交易日期
    ,nvl(n.main_module_cd, o.main_module_cd) as main_module_cd -- 主模块代码
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
from ${iml_schema}.agt_cent_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_cent_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.seq_num <> n.seq_num
        or o.cust_id <> n.cust_id
        or o.tran_ref_no <> n.tran_ref_no
        or o.ova_flow_num <> n.ova_flow_num
        or o.sys_sub_flow_num <> n.sys_sub_flow_num
        or o.evt_cate_cd <> n.evt_cate_cd
        or o.cent_type_cd <> n.cent_type_cd
        or o.cent <> n.cent
        or o.curr_cd <> n.curr_cd
        or o.amt_type_cd <> n.amt_type_cd
        or o.tran_code <> n.tran_code
        or o.tran_dt <> n.tran_dt
        or o.tran_status_cd <> n.tran_status_cd
        or o.tran_teller_id <> n.tran_teller_id
        or o.tran_org_id <> n.tran_org_id
        or o.revs_flg <> n.revs_flg
        or o.revs_flow_num <> n.revs_flow_num
        or o.revs_tran_code <> n.revs_tran_code
        or o.revs_tran_dt <> n.revs_tran_dt
        or o.revs_teller_id <> n.revs_teller_id
        or o.erase_acct_flg <> n.erase_acct_flg
        or o.revs_rs <> n.revs_rs
        or o.tran_tm <> n.tran_tm
        or o.clos_acct_flg <> n.clos_acct_flg
        or o.init_chn_flow_num <> n.init_chn_flow_num
        or o.init_chn_sub_flow_num <> n.init_chn_sub_flow_num
        or o.init_tran_amt <> n.init_tran_amt
        or o.init_tran_dt <> n.init_tran_dt
        or o.main_module_cd <> n.main_module_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cent_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,tran_ref_no -- 交易参考号
    ,ova_flow_num -- 全局流水号
    ,sys_sub_flow_num -- 系统子流水号
    ,evt_cate_cd -- 事件类别代码
    ,cent_type_cd -- 分位处理类型代码
    ,cent -- 分位金额
    ,curr_cd -- 币种代码
    ,amt_type_cd -- 金额类型代码
    ,tran_code -- 交易码
    ,tran_dt -- 交易日期
    ,tran_status_cd -- 交易状态代码
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,revs_flg -- 冲正标志
    ,revs_flow_num -- 冲正流水号
    ,revs_tran_code -- 冲正交易码
    ,revs_tran_dt -- 冲正交易日期
    ,revs_teller_id -- 冲正柜员编号
    ,erase_acct_flg -- 冲抹标志
    ,revs_rs -- 冲正原因
    ,tran_tm -- 交易时间
    ,clos_acct_flg -- 销户标志
    ,init_chn_flow_num -- 原渠道流水号
    ,init_chn_sub_flow_num -- 原渠道子流水号
    ,init_tran_amt -- 原交易金额
    ,init_tran_dt -- 原交易日期
    ,main_module_cd -- 主模块代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cent_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,tran_ref_no -- 交易参考号
    ,ova_flow_num -- 全局流水号
    ,sys_sub_flow_num -- 系统子流水号
    ,evt_cate_cd -- 事件类别代码
    ,cent_type_cd -- 分位处理类型代码
    ,cent -- 分位金额
    ,curr_cd -- 币种代码
    ,amt_type_cd -- 金额类型代码
    ,tran_code -- 交易码
    ,tran_dt -- 交易日期
    ,tran_status_cd -- 交易状态代码
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,revs_flg -- 冲正标志
    ,revs_flow_num -- 冲正流水号
    ,revs_tran_code -- 冲正交易码
    ,revs_tran_dt -- 冲正交易日期
    ,revs_teller_id -- 冲正柜员编号
    ,erase_acct_flg -- 冲抹标志
    ,revs_rs -- 冲正原因
    ,tran_tm -- 交易时间
    ,clos_acct_flg -- 销户标志
    ,init_chn_flow_num -- 原渠道流水号
    ,init_chn_sub_flow_num -- 原渠道子流水号
    ,init_tran_amt -- 原交易金额
    ,init_tran_dt -- 原交易日期
    ,main_module_cd -- 主模块代码
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
    ,o.seq_num -- 序号
    ,o.cust_id -- 客户编号
    ,o.tran_ref_no -- 交易参考号
    ,o.ova_flow_num -- 全局流水号
    ,o.sys_sub_flow_num -- 系统子流水号
    ,o.evt_cate_cd -- 事件类别代码
    ,o.cent_type_cd -- 分位处理类型代码
    ,o.cent -- 分位金额
    ,o.curr_cd -- 币种代码
    ,o.amt_type_cd -- 金额类型代码
    ,o.tran_code -- 交易码
    ,o.tran_dt -- 交易日期
    ,o.tran_status_cd -- 交易状态代码
    ,o.tran_teller_id -- 交易柜员编号
    ,o.tran_org_id -- 交易机构编号
    ,o.revs_flg -- 冲正标志
    ,o.revs_flow_num -- 冲正流水号
    ,o.revs_tran_code -- 冲正交易码
    ,o.revs_tran_dt -- 冲正交易日期
    ,o.revs_teller_id -- 冲正柜员编号
    ,o.erase_acct_flg -- 冲抹标志
    ,o.revs_rs -- 冲正原因
    ,o.tran_tm -- 交易时间
    ,o.clos_acct_flg -- 销户标志
    ,o.init_chn_flow_num -- 原渠道流水号
    ,o.init_chn_sub_flow_num -- 原渠道子流水号
    ,o.init_tran_amt -- 原交易金额
    ,o.init_tran_dt -- 原交易日期
    ,o.main_module_cd -- 主模块代码
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
from ${iml_schema}.agt_cent_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_cent_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_cent_info_h_ncbsf1_cl d
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
--truncate table ${iml_schema}.agt_cent_info_h;
--alter table ${iml_schema}.agt_cent_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_cent_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_cent_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_cent_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_cent_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_cent_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_cent_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_cent_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cent_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_cent_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cent_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cent_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_cent_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cent_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
