/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_tbox_cash_tran_flow_ncbsf1
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
alter table ${iml_schema}.ref_tbox_cash_tran_flow add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_tbox_cash_tran_flow partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_tm purge;
drop table ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_op purge;
drop table ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    tran_flow_num -- 转移流水号
    ,lp_id -- 法人编号
    ,tran_type_cd -- 转移类型代码
    ,tran_status_cd -- 转移状态代码
    ,tran_dt -- 转移日期
    ,tran_out_org_id -- 转出机构编号
    ,cntpty_org_type_cd -- 对手机构类型代码
    ,cntpty_org_id -- 对手机构编号
    ,tran_out_tail_box_id -- 转出尾箱编号
    ,cntpty_tail_box_id -- 对手尾箱编号
    ,tran_out_teller_id -- 转出柜员编号
    ,cntpty_teller_id -- 对手柜员编号
    ,tran_ref_no -- 转出交易参考号
    ,cntpty_tran_ref_no -- 对手交易参考号
    ,tran_code -- 交易码
    ,tran_descb -- 交易描述
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,cntpty_cust_id -- 对手客户编号
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_no -- 凭证号码
    ,pbc_cash_out_in_whs_type_cd -- 人行现金出入库类型代码
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_tbox_cash_tran_flow partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_tbox_cash_tran_flow partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_tbox_cash_tran_flow partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_tb_cash_move-1
insert into ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_tm(
    tran_flow_num -- 转移流水号
    ,lp_id -- 法人编号
    ,tran_type_cd -- 转移类型代码
    ,tran_status_cd -- 转移状态代码
    ,tran_dt -- 转移日期
    ,tran_out_org_id -- 转出机构编号
    ,cntpty_org_type_cd -- 对手机构类型代码
    ,cntpty_org_id -- 对手机构编号
    ,tran_out_tail_box_id -- 转出尾箱编号
    ,cntpty_tail_box_id -- 对手尾箱编号
    ,tran_out_teller_id -- 转出柜员编号
    ,cntpty_teller_id -- 对手柜员编号
    ,tran_ref_no -- 转出交易参考号
    ,cntpty_tran_ref_no -- 对手交易参考号
    ,tran_code -- 交易码
    ,tran_descb -- 交易描述
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,cntpty_cust_id -- 对手客户编号
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_no -- 凭证号码
    ,pbc_cash_out_in_whs_type_cd -- 人行现金出入库类型代码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.MOVE_ID -- 转移流水号
    ,'9999' -- 法人编号
    ,nvl(trim(P1.MOVE_TYPE),'-') -- 转移类型代码
    ,nvl(trim(P1.MOVE_STATUS),'-') -- 转移状态代码
    ,P1.TRAN_DATE -- 转移日期
    ,P1.FROM_BRANCH -- 转出机构编号
    ,nvl(trim(P1.CONTRA_BRANCH_TYPE),'-') -- 对手机构类型代码
    ,P1.TO_BRANCH -- 对手机构编号
    ,P1.FROM_TAILBOX_ID -- 转出尾箱编号
    ,P1.TO_TAILBOX_ID -- 对手尾箱编号
    ,P1.FROM_USER_ID -- 转出柜员编号
    ,P1.TO_USER_ID -- 对手柜员编号
    ,P1.REFERENCE -- 转出交易参考号
    ,P1.OTH_REFERENCE -- 对手交易参考号
    ,P1.PROD_TYPE -- 交易码
    ,P1.TRAN_DESC -- 交易描述
    ,P1.CLIENT_NO -- 客户编号
    ,P1.CLIENT_NAME -- 客户名称
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.CONTRA_CLIENT_NO -- 对手客户编号
    ,nvl(trim(P1.DOC_TYPE),'999') -- 凭证类型代码
    ,P1.VOUCHER_NO -- 凭证号码
    ,nvl(trim(P1.ACS_FLAG),'-') -- 人行现金出入库类型代码
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_tb_cash_move' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_tb_cash_move p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_tm 
  	                                group by 
  	                                        tran_flow_num
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
        into ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_cl(
            tran_flow_num -- 转移流水号
    ,lp_id -- 法人编号
    ,tran_type_cd -- 转移类型代码
    ,tran_status_cd -- 转移状态代码
    ,tran_dt -- 转移日期
    ,tran_out_org_id -- 转出机构编号
    ,cntpty_org_type_cd -- 对手机构类型代码
    ,cntpty_org_id -- 对手机构编号
    ,tran_out_tail_box_id -- 转出尾箱编号
    ,cntpty_tail_box_id -- 对手尾箱编号
    ,tran_out_teller_id -- 转出柜员编号
    ,cntpty_teller_id -- 对手柜员编号
    ,tran_ref_no -- 转出交易参考号
    ,cntpty_tran_ref_no -- 对手交易参考号
    ,tran_code -- 交易码
    ,tran_descb -- 交易描述
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,cntpty_cust_id -- 对手客户编号
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_no -- 凭证号码
    ,pbc_cash_out_in_whs_type_cd -- 人行现金出入库类型代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_op(
            tran_flow_num -- 转移流水号
    ,lp_id -- 法人编号
    ,tran_type_cd -- 转移类型代码
    ,tran_status_cd -- 转移状态代码
    ,tran_dt -- 转移日期
    ,tran_out_org_id -- 转出机构编号
    ,cntpty_org_type_cd -- 对手机构类型代码
    ,cntpty_org_id -- 对手机构编号
    ,tran_out_tail_box_id -- 转出尾箱编号
    ,cntpty_tail_box_id -- 对手尾箱编号
    ,tran_out_teller_id -- 转出柜员编号
    ,cntpty_teller_id -- 对手柜员编号
    ,tran_ref_no -- 转出交易参考号
    ,cntpty_tran_ref_no -- 对手交易参考号
    ,tran_code -- 交易码
    ,tran_descb -- 交易描述
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,cntpty_cust_id -- 对手客户编号
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_no -- 凭证号码
    ,pbc_cash_out_in_whs_type_cd -- 人行现金出入库类型代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 转移流水号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 转移类型代码
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 转移状态代码
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 转移日期
    ,nvl(n.tran_out_org_id, o.tran_out_org_id) as tran_out_org_id -- 转出机构编号
    ,nvl(n.cntpty_org_type_cd, o.cntpty_org_type_cd) as cntpty_org_type_cd -- 对手机构类型代码
    ,nvl(n.cntpty_org_id, o.cntpty_org_id) as cntpty_org_id -- 对手机构编号
    ,nvl(n.tran_out_tail_box_id, o.tran_out_tail_box_id) as tran_out_tail_box_id -- 转出尾箱编号
    ,nvl(n.cntpty_tail_box_id, o.cntpty_tail_box_id) as cntpty_tail_box_id -- 对手尾箱编号
    ,nvl(n.tran_out_teller_id, o.tran_out_teller_id) as tran_out_teller_id -- 转出柜员编号
    ,nvl(n.cntpty_teller_id, o.cntpty_teller_id) as cntpty_teller_id -- 对手柜员编号
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 转出交易参考号
    ,nvl(n.cntpty_tran_ref_no, o.cntpty_tran_ref_no) as cntpty_tran_ref_no -- 对手交易参考号
    ,nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.tran_descb, o.tran_descb) as tran_descb -- 交易描述
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.cntpty_cust_id, o.cntpty_cust_id) as cntpty_cust_id -- 对手客户编号
    ,nvl(n.vouch_type_cd, o.vouch_type_cd) as vouch_type_cd -- 凭证类型代码
    ,nvl(n.vouch_no, o.vouch_no) as vouch_no -- 凭证号码
    ,nvl(n.pbc_cash_out_in_whs_type_cd, o.pbc_cash_out_in_whs_type_cd) as pbc_cash_out_in_whs_type_cd -- 人行现金出入库类型代码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.tran_flow_num is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tran_flow_num is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tran_flow_num is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_tm n
    full join (select * from ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.tran_flow_num = n.tran_flow_num
            and o.lp_id = n.lp_id
where (
        o.tran_flow_num is null
        and o.lp_id is null
    )
    or (
        n.tran_flow_num is null
        and n.lp_id is null
    )
    or (
        o.tran_type_cd <> n.tran_type_cd
        or o.tran_status_cd <> n.tran_status_cd
        or o.tran_dt <> n.tran_dt
        or o.tran_out_org_id <> n.tran_out_org_id
        or o.cntpty_org_type_cd <> n.cntpty_org_type_cd
        or o.cntpty_org_id <> n.cntpty_org_id
        or o.tran_out_tail_box_id <> n.tran_out_tail_box_id
        or o.cntpty_tail_box_id <> n.cntpty_tail_box_id
        or o.tran_out_teller_id <> n.tran_out_teller_id
        or o.cntpty_teller_id <> n.cntpty_teller_id
        or o.tran_ref_no <> n.tran_ref_no
        or o.cntpty_tran_ref_no <> n.cntpty_tran_ref_no
        or o.tran_code <> n.tran_code
        or o.tran_descb <> n.tran_descb
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.cust_acct_num <> n.cust_acct_num
        or o.sub_acct_num <> n.sub_acct_num
        or o.cntpty_cust_id <> n.cntpty_cust_id
        or o.vouch_type_cd <> n.vouch_type_cd
        or o.vouch_no <> n.vouch_no
        or o.pbc_cash_out_in_whs_type_cd <> n.pbc_cash_out_in_whs_type_cd
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_cl(
            tran_flow_num -- 转移流水号
    ,lp_id -- 法人编号
    ,tran_type_cd -- 转移类型代码
    ,tran_status_cd -- 转移状态代码
    ,tran_dt -- 转移日期
    ,tran_out_org_id -- 转出机构编号
    ,cntpty_org_type_cd -- 对手机构类型代码
    ,cntpty_org_id -- 对手机构编号
    ,tran_out_tail_box_id -- 转出尾箱编号
    ,cntpty_tail_box_id -- 对手尾箱编号
    ,tran_out_teller_id -- 转出柜员编号
    ,cntpty_teller_id -- 对手柜员编号
    ,tran_ref_no -- 转出交易参考号
    ,cntpty_tran_ref_no -- 对手交易参考号
    ,tran_code -- 交易码
    ,tran_descb -- 交易描述
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,cntpty_cust_id -- 对手客户编号
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_no -- 凭证号码
    ,pbc_cash_out_in_whs_type_cd -- 人行现金出入库类型代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_op(
            tran_flow_num -- 转移流水号
    ,lp_id -- 法人编号
    ,tran_type_cd -- 转移类型代码
    ,tran_status_cd -- 转移状态代码
    ,tran_dt -- 转移日期
    ,tran_out_org_id -- 转出机构编号
    ,cntpty_org_type_cd -- 对手机构类型代码
    ,cntpty_org_id -- 对手机构编号
    ,tran_out_tail_box_id -- 转出尾箱编号
    ,cntpty_tail_box_id -- 对手尾箱编号
    ,tran_out_teller_id -- 转出柜员编号
    ,cntpty_teller_id -- 对手柜员编号
    ,tran_ref_no -- 转出交易参考号
    ,cntpty_tran_ref_no -- 对手交易参考号
    ,tran_code -- 交易码
    ,tran_descb -- 交易描述
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,cntpty_cust_id -- 对手客户编号
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_no -- 凭证号码
    ,pbc_cash_out_in_whs_type_cd -- 人行现金出入库类型代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tran_flow_num -- 转移流水号
    ,o.lp_id -- 法人编号
    ,o.tran_type_cd -- 转移类型代码
    ,o.tran_status_cd -- 转移状态代码
    ,o.tran_dt -- 转移日期
    ,o.tran_out_org_id -- 转出机构编号
    ,o.cntpty_org_type_cd -- 对手机构类型代码
    ,o.cntpty_org_id -- 对手机构编号
    ,o.tran_out_tail_box_id -- 转出尾箱编号
    ,o.cntpty_tail_box_id -- 对手尾箱编号
    ,o.tran_out_teller_id -- 转出柜员编号
    ,o.cntpty_teller_id -- 对手柜员编号
    ,o.tran_ref_no -- 转出交易参考号
    ,o.cntpty_tran_ref_no -- 对手交易参考号
    ,o.tran_code -- 交易码
    ,o.tran_descb -- 交易描述
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.cust_acct_num -- 客户账号
    ,o.sub_acct_num -- 子账号
    ,o.cntpty_cust_id -- 对手客户编号
    ,o.vouch_type_cd -- 凭证类型代码
    ,o.vouch_no -- 凭证号码
    ,o.pbc_cash_out_in_whs_type_cd -- 人行现金出入库类型代码
    ,o.remark -- 备注
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
from ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_bk o
    left join ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_op n
        on
            o.tran_flow_num = n.tran_flow_num
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_cl d
        on
            o.tran_flow_num = d.tran_flow_num
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_tbox_cash_tran_flow;
--alter table ${iml_schema}.ref_tbox_cash_tran_flow truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ref_tbox_cash_tran_flow') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ref_tbox_cash_tran_flow drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_tbox_cash_tran_flow modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ref_tbox_cash_tran_flow exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_cl;
alter table ${iml_schema}.ref_tbox_cash_tran_flow exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_tbox_cash_tran_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_tm purge;
drop table ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_op purge;
drop table ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_tbox_cash_tran_flow_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_tbox_cash_tran_flow', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
