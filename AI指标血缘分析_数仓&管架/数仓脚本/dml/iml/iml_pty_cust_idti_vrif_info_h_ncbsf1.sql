/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_cust_idti_vrif_info_h_ncbsf1
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
alter table ${iml_schema}.pty_cust_idti_vrif_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cust_idti_vrif_info_h partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_op purge;
drop table ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,bus_tran_batch_no -- 业务交易批次号
    ,rec_seq_num -- 记录顺序号
    ,vrif_rest_cd -- 核实结果代码
    ,vrif_chn_id -- 核实渠道编号
    ,unvrif_rs_descb -- 无法核实原因描述
    ,vrif_status_cd -- 核实状态代码
    ,vrif_dt -- 核实日期
    ,vrif_teller_id -- 核实柜员编号
    ,vrif_org_id -- 核实机构编号
    ,disp_way_cd -- 处置方式代码
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cust_idti_vrif_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cust_idti_vrif_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cust_idti_vrif_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cif_client_verification
insert into ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,bus_tran_batch_no -- 业务交易批次号
    ,rec_seq_num -- 记录顺序号
    ,vrif_rest_cd -- 核实结果代码
    ,vrif_chn_id -- 核实渠道编号
    ,unvrif_rs_descb -- 无法核实原因描述
    ,vrif_status_cd -- 核实状态代码
    ,vrif_dt -- 核实日期
    ,vrif_teller_id -- 核实柜员编号
    ,vrif_org_id -- 核实机构编号
    ,disp_way_cd -- 处置方式代码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CLIENT_NO -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.BATCH_NO -- 业务交易批次号
    ,P1.SEQ_NO -- 记录顺序号
    ,P1.VERIFICATION_RESULT -- 核实结果代码
    ,P1.VERIFICATION_SOURCE_TYPE -- 核实渠道编号
    ,P1.UNVERIFICATION_REASON -- 无法核实原因描述
    ,P1.VERIFY_STATUS -- 核实状态代码
    ,${iml_schema}.dateformat_max2(P1.VERIFICATION_DATE) -- 核实日期
    ,P1.VERIFICATION_USER_ID -- 核实柜员编号
    ,P1.VERIFICATION_BRANCH -- 核实机构编号
    ,P1.TREATMENT -- 处置方式代码
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cif_client_verification' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cif_client_verification p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                                        ,cust_id
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
        into ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,bus_tran_batch_no -- 业务交易批次号
    ,rec_seq_num -- 记录顺序号
    ,vrif_rest_cd -- 核实结果代码
    ,vrif_chn_id -- 核实渠道编号
    ,unvrif_rs_descb -- 无法核实原因描述
    ,vrif_status_cd -- 核实状态代码
    ,vrif_dt -- 核实日期
    ,vrif_teller_id -- 核实柜员编号
    ,vrif_org_id -- 核实机构编号
    ,disp_way_cd -- 处置方式代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,bus_tran_batch_no -- 业务交易批次号
    ,rec_seq_num -- 记录顺序号
    ,vrif_rest_cd -- 核实结果代码
    ,vrif_chn_id -- 核实渠道编号
    ,unvrif_rs_descb -- 无法核实原因描述
    ,vrif_status_cd -- 核实状态代码
    ,vrif_dt -- 核实日期
    ,vrif_teller_id -- 核实柜员编号
    ,vrif_org_id -- 核实机构编号
    ,disp_way_cd -- 处置方式代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.bus_tran_batch_no, o.bus_tran_batch_no) as bus_tran_batch_no -- 业务交易批次号
    ,nvl(n.rec_seq_num, o.rec_seq_num) as rec_seq_num -- 记录顺序号
    ,nvl(n.vrif_rest_cd, o.vrif_rest_cd) as vrif_rest_cd -- 核实结果代码
    ,nvl(n.vrif_chn_id, o.vrif_chn_id) as vrif_chn_id -- 核实渠道编号
    ,nvl(n.unvrif_rs_descb, o.unvrif_rs_descb) as unvrif_rs_descb -- 无法核实原因描述
    ,nvl(n.vrif_status_cd, o.vrif_status_cd) as vrif_status_cd -- 核实状态代码
    ,nvl(n.vrif_dt, o.vrif_dt) as vrif_dt -- 核实日期
    ,nvl(n.vrif_teller_id, o.vrif_teller_id) as vrif_teller_id -- 核实柜员编号
    ,nvl(n.vrif_org_id, o.vrif_org_id) as vrif_org_id -- 核实机构编号
    ,nvl(n.disp_way_cd, o.disp_way_cd) as disp_way_cd -- 处置方式代码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.cust_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.cust_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.cust_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.cust_id = n.cust_id
where (
        o.party_id is null
        and o.lp_id is null
        and o.cust_id is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
        and n.cust_id is null
    )
    or (
        o.bus_tran_batch_no <> n.bus_tran_batch_no
        or o.rec_seq_num <> n.rec_seq_num
        or o.vrif_rest_cd <> n.vrif_rest_cd
        or o.vrif_chn_id <> n.vrif_chn_id
        or o.unvrif_rs_descb <> n.unvrif_rs_descb
        or o.vrif_status_cd <> n.vrif_status_cd
        or o.vrif_dt <> n.vrif_dt
        or o.vrif_teller_id <> n.vrif_teller_id
        or o.vrif_org_id <> n.vrif_org_id
        or o.disp_way_cd <> n.disp_way_cd
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,bus_tran_batch_no -- 业务交易批次号
    ,rec_seq_num -- 记录顺序号
    ,vrif_rest_cd -- 核实结果代码
    ,vrif_chn_id -- 核实渠道编号
    ,unvrif_rs_descb -- 无法核实原因描述
    ,vrif_status_cd -- 核实状态代码
    ,vrif_dt -- 核实日期
    ,vrif_teller_id -- 核实柜员编号
    ,vrif_org_id -- 核实机构编号
    ,disp_way_cd -- 处置方式代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,bus_tran_batch_no -- 业务交易批次号
    ,rec_seq_num -- 记录顺序号
    ,vrif_rest_cd -- 核实结果代码
    ,vrif_chn_id -- 核实渠道编号
    ,unvrif_rs_descb -- 无法核实原因描述
    ,vrif_status_cd -- 核实状态代码
    ,vrif_dt -- 核实日期
    ,vrif_teller_id -- 核实柜员编号
    ,vrif_org_id -- 核实机构编号
    ,disp_way_cd -- 处置方式代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.cust_id -- 客户编号
    ,o.bus_tran_batch_no -- 业务交易批次号
    ,o.rec_seq_num -- 记录顺序号
    ,o.vrif_rest_cd -- 核实结果代码
    ,o.vrif_chn_id -- 核实渠道编号
    ,o.unvrif_rs_descb -- 无法核实原因描述
    ,o.vrif_status_cd -- 核实状态代码
    ,o.vrif_dt -- 核实日期
    ,o.vrif_teller_id -- 核实柜员编号
    ,o.vrif_org_id -- 核实机构编号
    ,o.disp_way_cd -- 处置方式代码
    ,o.remark -- 备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_bk o
    left join ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.cust_id = n.cust_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.cust_id = d.cust_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_cust_idti_vrif_info_h;
alter table ${iml_schema}.pty_cust_idti_vrif_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.pty_cust_idti_vrif_info_h exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_cl;
alter table ${iml_schema}.pty_cust_idti_vrif_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_cust_idti_vrif_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_op purge;
drop table ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_cust_idti_vrif_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_cust_idti_vrif_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
