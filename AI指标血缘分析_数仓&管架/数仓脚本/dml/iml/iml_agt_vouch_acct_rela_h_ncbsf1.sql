/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_vouch_acct_rela_h_ncbsf1
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
alter table ${iml_schema}.agt_vouch_acct_rela_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_vouch_acct_rela_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,card_no -- 卡号
    ,vouch_kind_cd -- 凭证种类代码
    ,vouch_status_cd -- 凭证状态代码
    ,vouch_orig_status_cd -- 凭证原状态代码
    ,tran_ref_no -- 交易参考号
    ,pm_flg -- 抵质押标志
    ,pm_id -- 抵质押编号
    ,cust_id -- 客户编号
    ,tran_memo_descb -- 交易摘要描述
    ,tran_dt -- 交易日期
    ,tran_timestamp -- 交易时间
    ,cancel_rs_cd -- 作废原因代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_vouch_acct_rela_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_vouch_acct_rela_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_vouch_acct_rela_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_voucher_acct_relation-1
insert into ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,card_no -- 卡号
    ,vouch_kind_cd -- 凭证种类代码
    ,vouch_status_cd -- 凭证状态代码
    ,vouch_orig_status_cd -- 凭证原状态代码
    ,tran_ref_no -- 交易参考号
    ,pm_flg -- 抵质押标志
    ,pm_id -- 抵质押编号
    ,cust_id -- 客户编号
    ,tran_memo_descb -- 交易摘要描述
    ,tran_dt -- 交易日期
    ,tran_timestamp -- 交易时间
    ,cancel_rs_cd -- 作废原因代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '140010'||P1.BASE_ACCT_NO -- 协议编号
    ,'9999' -- 法人编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.DOC_TYPE -- 存款凭证类别代码
    ,P1.VOUCHER_NO -- 凭证号码
    ,P1.PROD_TYPE -- 产品编号
    ,P1.ACCT_CCY -- 币种代码
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.CARD_NO -- 卡号
    ,P1.DOC_CLASS -- 凭证种类代码
    ,P1.VOUCHER_STATUS -- 凭证状态代码
    ,P1.OLD_STATUS -- 凭证原状态代码
    ,P1.REFERENCE -- 交易参考号
    ,decode(trim(p1.COLLAT_IND),'','-','Y','1','N','0',p1.COLLAT_IND) -- 抵质押标志
    ,P1.COLLAT_NO -- 抵质押编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.NARRATIVE -- 交易摘要描述
    ,P1.TRAN_DATE -- 交易日期
    ,iml.timeformat_max(P1.TRAN_TIMESTAMP) -- 交易时间
    ,nvl(trim(P1.CAN_REASON_CODE),'-') -- 作废原因代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_voucher_acct_relation' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_voucher_acct_relation p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,cust_acct_num
  	                                        ,dep_vouch_cate_cd
  	                                        ,vouch_no
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
        into ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,card_no -- 卡号
    ,vouch_kind_cd -- 凭证种类代码
    ,vouch_status_cd -- 凭证状态代码
    ,vouch_orig_status_cd -- 凭证原状态代码
    ,tran_ref_no -- 交易参考号
    ,pm_flg -- 抵质押标志
    ,pm_id -- 抵质押编号
    ,cust_id -- 客户编号
    ,tran_memo_descb -- 交易摘要描述
    ,tran_dt -- 交易日期
    ,tran_timestamp -- 交易时间
    ,cancel_rs_cd -- 作废原因代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,card_no -- 卡号
    ,vouch_kind_cd -- 凭证种类代码
    ,vouch_status_cd -- 凭证状态代码
    ,vouch_orig_status_cd -- 凭证原状态代码
    ,tran_ref_no -- 交易参考号
    ,pm_flg -- 抵质押标志
    ,pm_id -- 抵质押编号
    ,cust_id -- 客户编号
    ,tran_memo_descb -- 交易摘要描述
    ,tran_dt -- 交易日期
    ,tran_timestamp -- 交易时间
    ,cancel_rs_cd -- 作废原因代码
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
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.dep_vouch_cate_cd, o.dep_vouch_cate_cd) as dep_vouch_cate_cd -- 存款凭证类别代码
    ,nvl(n.vouch_no, o.vouch_no) as vouch_no -- 凭证号码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.vouch_kind_cd, o.vouch_kind_cd) as vouch_kind_cd -- 凭证种类代码
    ,nvl(n.vouch_status_cd, o.vouch_status_cd) as vouch_status_cd -- 凭证状态代码
    ,nvl(n.vouch_orig_status_cd, o.vouch_orig_status_cd) as vouch_orig_status_cd -- 凭证原状态代码
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.pm_flg, o.pm_flg) as pm_flg -- 抵质押标志
    ,nvl(n.pm_id, o.pm_id) as pm_id -- 抵质押编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.tran_memo_descb, o.tran_memo_descb) as tran_memo_descb -- 交易摘要描述
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间
    ,nvl(n.cancel_rs_cd, o.cancel_rs_cd) as cancel_rs_cd -- 作废原因代码
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cust_acct_num is null
            and n.dep_vouch_cate_cd is null
            and n.vouch_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cust_acct_num is null
            and n.dep_vouch_cate_cd is null
            and n.vouch_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cust_acct_num is null
            and n.dep_vouch_cate_cd is null
            and n.vouch_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.cust_acct_num = n.cust_acct_num
            and o.dep_vouch_cate_cd = n.dep_vouch_cate_cd
            and o.vouch_no = n.vouch_no
where (
        o.agt_id is null
        and o.lp_id is null
        and o.cust_acct_num is null
        and o.dep_vouch_cate_cd is null
        and o.vouch_no is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.cust_acct_num is null
        and n.dep_vouch_cate_cd is null
        and n.vouch_no is null
    )
    or (
        o.prod_id <> n.prod_id
        or o.curr_cd <> n.curr_cd
        or o.sub_acct_num <> n.sub_acct_num
        or o.card_no <> n.card_no
        or o.vouch_kind_cd <> n.vouch_kind_cd
        or o.vouch_status_cd <> n.vouch_status_cd
        or o.vouch_orig_status_cd <> n.vouch_orig_status_cd
        or o.tran_ref_no <> n.tran_ref_no
        or o.pm_flg <> n.pm_flg
        or o.pm_id <> n.pm_id
        or o.cust_id <> n.cust_id
        or o.tran_memo_descb <> n.tran_memo_descb
        or o.tran_dt <> n.tran_dt
        or o.tran_timestamp <> n.tran_timestamp
        or o.cancel_rs_cd <> n.cancel_rs_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,card_no -- 卡号
    ,vouch_kind_cd -- 凭证种类代码
    ,vouch_status_cd -- 凭证状态代码
    ,vouch_orig_status_cd -- 凭证原状态代码
    ,tran_ref_no -- 交易参考号
    ,pm_flg -- 抵质押标志
    ,pm_id -- 抵质押编号
    ,cust_id -- 客户编号
    ,tran_memo_descb -- 交易摘要描述
    ,tran_dt -- 交易日期
    ,tran_timestamp -- 交易时间
    ,cancel_rs_cd -- 作废原因代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,card_no -- 卡号
    ,vouch_kind_cd -- 凭证种类代码
    ,vouch_status_cd -- 凭证状态代码
    ,vouch_orig_status_cd -- 凭证原状态代码
    ,tran_ref_no -- 交易参考号
    ,pm_flg -- 抵质押标志
    ,pm_id -- 抵质押编号
    ,cust_id -- 客户编号
    ,tran_memo_descb -- 交易摘要描述
    ,tran_dt -- 交易日期
    ,tran_timestamp -- 交易时间
    ,cancel_rs_cd -- 作废原因代码
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
    ,o.cust_acct_num -- 客户账号
    ,o.dep_vouch_cate_cd -- 存款凭证类别代码
    ,o.vouch_no -- 凭证号码
    ,o.prod_id -- 产品编号
    ,o.curr_cd -- 币种代码
    ,o.sub_acct_num -- 子账号
    ,o.card_no -- 卡号
    ,o.vouch_kind_cd -- 凭证种类代码
    ,o.vouch_status_cd -- 凭证状态代码
    ,o.vouch_orig_status_cd -- 凭证原状态代码
    ,o.tran_ref_no -- 交易参考号
    ,o.pm_flg -- 抵质押标志
    ,o.pm_id -- 抵质押编号
    ,o.cust_id -- 客户编号
    ,o.tran_memo_descb -- 交易摘要描述
    ,o.tran_dt -- 交易日期
    ,o.tran_timestamp -- 交易时间
    ,o.cancel_rs_cd -- 作废原因代码
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
from ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_bk o
    left join ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.cust_acct_num = n.cust_acct_num
            and o.dep_vouch_cate_cd = n.dep_vouch_cate_cd
            and o.vouch_no = n.vouch_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.cust_acct_num = d.cust_acct_num
            and o.dep_vouch_cate_cd = d.dep_vouch_cate_cd
            and o.vouch_no = d.vouch_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_vouch_acct_rela_h;
--alter table ${iml_schema}.agt_vouch_acct_rela_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_vouch_acct_rela_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_vouch_acct_rela_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_vouch_acct_rela_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_vouch_acct_rela_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_cl;
alter table ${iml_schema}.agt_vouch_acct_rela_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_vouch_acct_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_vouch_acct_rela_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_vouch_acct_rela_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
