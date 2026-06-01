/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_acct_lmt_type_para_ncbsf1
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
alter table ${iml_schema}.ref_acct_lmt_type_para add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_acct_lmt_type_para partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    lp_id -- 法人编号
    ,lmt_type_cd -- 限制类型代码
    ,lmt_type_descb -- 限制类型描述
    ,lmt_type_cate_cd -- 限制类型类别代码
    ,froz_lev -- 冻结级别
    ,manual_froz_flg -- 手工冻结标志
    ,manual_unfrz_flg -- 手工解冻标志
    ,full_amt_stop_pay_flg -- 全额止付标志
    ,sys_spec_flg -- 系统专用标志
    ,auth_org_froz_flg -- 有权机关冻结标志
    ,eod_deduct_flg -- EOD扣款标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_acct_lmt_type_para partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_acct_lmt_type_para partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_acct_lmt_type_para partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_fm_restraint_type-1
insert into ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_tm(
    lp_id -- 法人编号
    ,lmt_type_cd -- 限制类型代码
    ,lmt_type_descb -- 限制类型描述
    ,lmt_type_cate_cd -- 限制类型类别代码
    ,froz_lev -- 冻结级别
    ,manual_froz_flg -- 手工冻结标志
    ,manual_unfrz_flg -- 手工解冻标志
    ,full_amt_stop_pay_flg -- 全额止付标志
    ,sys_spec_flg -- 系统专用标志
    ,auth_org_froz_flg -- 有权机关冻结标志
    ,eod_deduct_flg -- EOD扣款标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '9999' -- 法人编号
    ,nvl(trim(P1.RESTRAINT_TYPE),'-') -- 限制类型代码
    ,P1.RESTRAINT_TYPE_DESC -- 限制类型描述
    ,nvl(trim(P1.RESTRAINT_CLASS),'-') -- 限制类型类别代码
    ,P1.RES_PRIORITY -- 冻结级别
    ,DECODE(TRIM(P1.MANUAL_RES_FLAG),'','-','Y','1','N','0',P1.MANUAL_RES_FLAG) -- 手工冻结标志
    ,DECODE(TRIM(P1.MANUAL_UNRES_FLAG),'','-','Y','1','N','0',P1.MANUAL_UNRES_FLAG) -- 手工解冻标志
    ,DECODE(TRIM(P1.STOP_WTD_FLAG),'','-','Y','1','N','0',P1.STOP_WTD_FLAG) -- 全额止付标志
    ,DECODE(TRIM(P1.SYSTEM_USE_FLAG),'','-','Y','1','N','0',P1.SYSTEM_USE_FLAG) -- 系统专用标志
    ,DECODE(TRIM(P1.AH_BU_FLAG),'','-','Y','1','N','0',P1.AH_BU_FLAG) -- 有权机关冻结标志
    ,DECODE(TRIM(P1.EOD_IMPOUND_FLAG),'','-','Y','1','N','0',P1.EOD_IMPOUND_FLAG) -- EOD扣款标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_fm_restraint_type' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_fm_restraint_type p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_tm 
  	                                group by 
  	                                        lp_id
  	                                        ,lmt_type_cd
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
        into ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_cl(
            lp_id -- 法人编号
    ,lmt_type_cd -- 限制类型代码
    ,lmt_type_descb -- 限制类型描述
    ,lmt_type_cate_cd -- 限制类型类别代码
    ,froz_lev -- 冻结级别
    ,manual_froz_flg -- 手工冻结标志
    ,manual_unfrz_flg -- 手工解冻标志
    ,full_amt_stop_pay_flg -- 全额止付标志
    ,sys_spec_flg -- 系统专用标志
    ,auth_org_froz_flg -- 有权机关冻结标志
    ,eod_deduct_flg -- EOD扣款标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_op(
            lp_id -- 法人编号
    ,lmt_type_cd -- 限制类型代码
    ,lmt_type_descb -- 限制类型描述
    ,lmt_type_cate_cd -- 限制类型类别代码
    ,froz_lev -- 冻结级别
    ,manual_froz_flg -- 手工冻结标志
    ,manual_unfrz_flg -- 手工解冻标志
    ,full_amt_stop_pay_flg -- 全额止付标志
    ,sys_spec_flg -- 系统专用标志
    ,auth_org_froz_flg -- 有权机关冻结标志
    ,eod_deduct_flg -- EOD扣款标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.lmt_type_cd, o.lmt_type_cd) as lmt_type_cd -- 限制类型代码
    ,nvl(n.lmt_type_descb, o.lmt_type_descb) as lmt_type_descb -- 限制类型描述
    ,nvl(n.lmt_type_cate_cd, o.lmt_type_cate_cd) as lmt_type_cate_cd -- 限制类型类别代码
    ,nvl(n.froz_lev, o.froz_lev) as froz_lev -- 冻结级别
    ,nvl(n.manual_froz_flg, o.manual_froz_flg) as manual_froz_flg -- 手工冻结标志
    ,nvl(n.manual_unfrz_flg, o.manual_unfrz_flg) as manual_unfrz_flg -- 手工解冻标志
    ,nvl(n.full_amt_stop_pay_flg, o.full_amt_stop_pay_flg) as full_amt_stop_pay_flg -- 全额止付标志
    ,nvl(n.sys_spec_flg, o.sys_spec_flg) as sys_spec_flg -- 系统专用标志
    ,nvl(n.auth_org_froz_flg, o.auth_org_froz_flg) as auth_org_froz_flg -- 有权机关冻结标志
    ,nvl(n.eod_deduct_flg, o.eod_deduct_flg) as eod_deduct_flg -- EOD扣款标志
    ,case when
            n.lp_id is null
            and n.lmt_type_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.lp_id is null
            and n.lmt_type_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.lp_id is null
            and n.lmt_type_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_tm n
    full join (select * from ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.lp_id = n.lp_id
            and o.lmt_type_cd = n.lmt_type_cd
where (
        o.lp_id is null
        and o.lmt_type_cd is null
    )
    or (
        n.lp_id is null
        and n.lmt_type_cd is null
    )
    or (
        o.lmt_type_descb <> n.lmt_type_descb
        or o.lmt_type_cate_cd <> n.lmt_type_cate_cd
        or o.froz_lev <> n.froz_lev
        or o.manual_froz_flg <> n.manual_froz_flg
        or o.manual_unfrz_flg <> n.manual_unfrz_flg
        or o.full_amt_stop_pay_flg <> n.full_amt_stop_pay_flg
        or o.sys_spec_flg <> n.sys_spec_flg
        or o.auth_org_froz_flg <> n.auth_org_froz_flg
        or o.eod_deduct_flg <> n.eod_deduct_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_cl(
            lp_id -- 法人编号
    ,lmt_type_cd -- 限制类型代码
    ,lmt_type_descb -- 限制类型描述
    ,lmt_type_cate_cd -- 限制类型类别代码
    ,froz_lev -- 冻结级别
    ,manual_froz_flg -- 手工冻结标志
    ,manual_unfrz_flg -- 手工解冻标志
    ,full_amt_stop_pay_flg -- 全额止付标志
    ,sys_spec_flg -- 系统专用标志
    ,auth_org_froz_flg -- 有权机关冻结标志
    ,eod_deduct_flg -- EOD扣款标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_op(
            lp_id -- 法人编号
    ,lmt_type_cd -- 限制类型代码
    ,lmt_type_descb -- 限制类型描述
    ,lmt_type_cate_cd -- 限制类型类别代码
    ,froz_lev -- 冻结级别
    ,manual_froz_flg -- 手工冻结标志
    ,manual_unfrz_flg -- 手工解冻标志
    ,full_amt_stop_pay_flg -- 全额止付标志
    ,sys_spec_flg -- 系统专用标志
    ,auth_org_froz_flg -- 有权机关冻结标志
    ,eod_deduct_flg -- EOD扣款标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.lp_id -- 法人编号
    ,o.lmt_type_cd -- 限制类型代码
    ,o.lmt_type_descb -- 限制类型描述
    ,o.lmt_type_cate_cd -- 限制类型类别代码
    ,o.froz_lev -- 冻结级别
    ,o.manual_froz_flg -- 手工冻结标志
    ,o.manual_unfrz_flg -- 手工解冻标志
    ,o.full_amt_stop_pay_flg -- 全额止付标志
    ,o.sys_spec_flg -- 系统专用标志
    ,o.auth_org_froz_flg -- 有权机关冻结标志
    ,o.eod_deduct_flg -- EOD扣款标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_bk o
    left join ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_op n
        on
            o.lp_id = n.lp_id
            and o.lmt_type_cd = n.lmt_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_cl d
        on
            o.lp_id = d.lp_id
            and o.lmt_type_cd = d.lmt_type_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_acct_lmt_type_para;
alter table ${iml_schema}.ref_acct_lmt_type_para truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_acct_lmt_type_para exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_cl;
alter table ${iml_schema}.ref_acct_lmt_type_para exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_acct_lmt_type_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_acct_lmt_type_para_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_acct_lmt_type_para', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
