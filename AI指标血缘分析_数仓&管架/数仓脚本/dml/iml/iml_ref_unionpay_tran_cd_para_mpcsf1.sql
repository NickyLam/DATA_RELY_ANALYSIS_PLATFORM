/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_unionpay_tran_cd_para_mpcsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_unionpay_tran_cd_para_mpcsf1_tm purge;
drop table ${iml_schema}.ref_unionpay_tran_cd_para_mpcsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ref_unionpay_tran_cd_para add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_unionpay_tran_cd_para modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_unionpay_tran_cd_para_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_unionpay_tran_cd_para partition for ('mpcsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_unionpay_tran_cd_para_mpcsf1_tm
compress ${option_switch} for query high
as
select
    msg_type_cd -- 报文类型代码
    ,tran_proc_cd -- 交易处理代码
    ,tran_serv_cond_cd -- 交易服务点条件代码
    ,intnal_tran_cd -- 内部交易代码
    ,unionpay_tran_cd -- 银联交易代码
    ,return_msg_type_cd -- 返回报文类型代码
    ,tran_name -- 交易名称
    ,fobid_flg -- 禁用标志
    ,deflt_memo_cd -- 默认摘要代码
    ,memo_name -- 摘要名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_unionpay_tran_cd_para
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ref_unionpay_tran_cd_para_mpcsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ref_unionpay_tran_cd_para partition for ('mpcsf1') where 0=1;

-- 2.1 insert data to tm table
-- mpcs_a51ttrncdmap-  
insert into ${iml_schema}.ref_unionpay_tran_cd_para_mpcsf1_tm(
    msg_type_cd -- 报文类型代码
    ,tran_proc_cd -- 交易处理代码
    ,tran_serv_cond_cd -- 交易服务点条件代码
    ,intnal_tran_cd -- 内部交易代码
    ,unionpay_tran_cd -- 银联交易代码
    ,return_msg_type_cd -- 返回报文类型代码
    ,tran_name -- 交易名称
    ,fobid_flg -- 禁用标志
    ,deflt_memo_cd -- 默认摘要代码
    ,memo_name -- 摘要名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.msgtype -- 报文类型代码
    ,P1.fld003 -- 交易处理代码
    ,P1.fld025 -- 交易服务点条件代码
    ,P1.trncd -- 内部交易代码
    ,P1.cbstrncd -- 银联交易代码
    ,P1.rsmsgtype -- 返回报文类型代码
    ,P1.trnname -- 交易名称
    ,P1.isstop -- 禁用标志
    ,P1.memocd -- 默认摘要代码
    ,P1.memo -- 摘要名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a51ttrncdmap' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a51ttrncdmap p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_unionpay_tran_cd_para_mpcsf1_tm 
  	                                group by 
  	                                        msg_type_cd
  	                                        ,tran_proc_cd
  	                                        ,tran_serv_cond_cd
  	                                        ,intnal_tran_cd
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.ref_unionpay_tran_cd_para_mpcsf1_ex(
    msg_type_cd -- 报文类型代码
    ,tran_proc_cd -- 交易处理代码
    ,tran_serv_cond_cd -- 交易服务点条件代码
    ,intnal_tran_cd -- 内部交易代码
    ,unionpay_tran_cd -- 银联交易代码
    ,return_msg_type_cd -- 返回报文类型代码
    ,tran_name -- 交易名称
    ,fobid_flg -- 禁用标志
    ,deflt_memo_cd -- 默认摘要代码
    ,memo_name -- 摘要名称
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.msg_type_cd, o.msg_type_cd) as msg_type_cd -- 报文类型代码
    ,nvl(n.tran_proc_cd, o.tran_proc_cd) as tran_proc_cd -- 交易处理代码
    ,nvl(n.tran_serv_cond_cd, o.tran_serv_cond_cd) as tran_serv_cond_cd -- 交易服务点条件代码
    ,nvl(n.intnal_tran_cd, o.intnal_tran_cd) as intnal_tran_cd -- 内部交易代码
    ,nvl(n.unionpay_tran_cd, o.unionpay_tran_cd) as unionpay_tran_cd -- 银联交易代码
    ,nvl(n.return_msg_type_cd, o.return_msg_type_cd) as return_msg_type_cd -- 返回报文类型代码
    ,nvl(n.tran_name, o.tran_name) as tran_name -- 交易名称
    ,nvl(n.fobid_flg, o.fobid_flg) as fobid_flg -- 禁用标志
    ,nvl(n.deflt_memo_cd, o.deflt_memo_cd) as deflt_memo_cd -- 默认摘要代码
    ,nvl(n.memo_name, o.memo_name) as memo_name -- 摘要名称
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.msg_type_cd is null
                and o.tran_proc_cd is null
                and o.tran_serv_cond_cd is null
                and o.intnal_tran_cd is null
            ) or (
                o.unionpay_tran_cd <> n.unionpay_tran_cd
                or o.return_msg_type_cd <> n.return_msg_type_cd
                or o.tran_name <> n.tran_name
                or o.fobid_flg <> n.fobid_flg
                or o.deflt_memo_cd <> n.deflt_memo_cd
                or o.memo_name <> n.memo_name
            ) or (
                 case when (
                           n.msg_type_cd is null
                           and n.tran_proc_cd is null
                           and n.tran_serv_cond_cd is null
                           and n.intnal_tran_cd is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.msg_type_cd is null
                and n.tran_proc_cd is null
                and n.tran_serv_cond_cd is null
                and n.intnal_tran_cd is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_unionpay_tran_cd_para_mpcsf1_tm n
    full join ${iml_schema}.ref_unionpay_tran_cd_para_mpcsf1_bk o
        on
            o.msg_type_cd = n.msg_type_cd
            and o.tran_proc_cd = n.tran_proc_cd
            and o.tran_serv_cond_cd = n.tran_serv_cond_cd
            and o.intnal_tran_cd = n.intnal_tran_cd
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_unionpay_tran_cd_para truncate partition for ('mpcsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ref_unionpay_tran_cd_para exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.ref_unionpay_tran_cd_para_mpcsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_unionpay_tran_cd_para drop subpartition p_mpcsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_unionpay_tran_cd_para to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_unionpay_tran_cd_para_mpcsf1_tm purge;
drop table ${iml_schema}.ref_unionpay_tran_cd_para_mpcsf1_ex purge;
drop table ${iml_schema}.ref_unionpay_tran_cd_para_mpcsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_unionpay_tran_cd_para', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);