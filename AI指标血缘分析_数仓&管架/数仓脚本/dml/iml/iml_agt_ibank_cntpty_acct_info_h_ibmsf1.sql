/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ibank_cntpty_acct_info_h_ibmsf1
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
alter table ${iml_schema}.agt_ibank_cntpty_acct_info_h add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ibmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ibank_cntpty_acct_info_h partition for ('ibmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_tm purge;
drop table ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_op purge;
drop table ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,org_id -- 机构编号
    ,bank_acct_id -- 银行账户编号
    ,bank_acct_name -- 银行账户名称
    ,curr_cd -- 币种代码
    ,mgmt_org_id -- 管理机构编号
    ,mdl_bank_acct_id -- 中间行账户编号
    ,mdl_bank_name -- 中间行名称
    ,mdl_bank_swift_cd -- 中间行SWIFT代码
    ,open_bank_acct_id -- 开户行账户编号
    ,open_bank_name -- 开户行名称
    ,open_bank_swift_cd -- 开户行SWIFT代码
    ,ghb_recv_bank_acct_name -- 本方收款行账户名称
    ,ghb_recv_bank_acct_swift_cd -- 本方收款行SWIFT代码
    ,pay_type_cd -- 支付类型代码
    ,dlvy_msg_cd -- 交割报文代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ibank_cntpty_acct_info_h partition for ('ibmsf1')
where 0=1
;

create table ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ibank_cntpty_acct_info_h partition for ('ibmsf1') where 0=1;

create table ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ibank_cntpty_acct_info_h partition for ('ibmsf1') where 0=1;

-- 3.1 get new data into table
-- ibms_ttrd_countparty_bankacct-
insert into ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,org_id -- 机构编号
    ,bank_acct_id -- 银行账户编号
    ,bank_acct_name -- 银行账户名称
    ,curr_cd -- 币种代码
    ,mgmt_org_id -- 管理机构编号
    ,mdl_bank_acct_id -- 中间行账户编号
    ,mdl_bank_name -- 中间行名称
    ,mdl_bank_swift_cd -- 中间行SWIFT代码
    ,open_bank_acct_id -- 开户行账户编号
    ,open_bank_name -- 开户行名称
    ,open_bank_swift_cd -- 开户行SWIFT代码
    ,ghb_recv_bank_acct_name -- 本方收款行账户名称
    ,ghb_recv_bank_acct_swift_cd -- 本方收款行SWIFT代码
    ,pay_type_cd -- 支付类型代码
    ,dlvy_msg_cd -- 交割报文代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '231041'||P1.ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ID -- 源协议编号
    ,P1.I_ID -- 机构编号
    ,P1.BANK_ACCT -- 银行账户编号
    ,P1.BANK_ACCT_NAME -- 银行账户名称
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.B_I_ID -- 管理机构编号
    ,P1.MID_BANK_ACCT_CODE -- 中间行账户编号
    ,P1.MID_BANK_NAME -- 中间行名称
    ,P1.MID_SWIFT_CODE -- 中间行SWIFT代码
    ,P1.BANK_CODE -- 开户行账户编号
    ,P1.BANK_NAME -- 开户行名称
    ,P1.SWIFT_CODE -- 开户行SWIFT代码
    ,P1.RECV_BANK_NAME -- 本方收款行账户名称
    ,P1.RECV_BANK_SWIFT_CODE -- 本方收款行SWIFT代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.ACC_CODE_TYPE END -- 支付类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.SWIFT_TYPE END -- 交割报文代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_countparty_bankacct' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_countparty_bankacct p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ACC_CODE_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_COUNTPARTY_BANKACCT'
        AND R1.SRC_FIELD_EN_NAME= 'ACC_CODE_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_IBANK_CNTPTY_ACCT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PAY_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.SWIFT_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_COUNTPARTY_BANKACCT'
        AND R2.SRC_FIELD_EN_NAME= 'SWIFT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_IBANK_CNTPTY_ACCT_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'DLVY_MSG_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_tm 
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
        into ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,org_id -- 机构编号
    ,bank_acct_id -- 银行账户编号
    ,bank_acct_name -- 银行账户名称
    ,curr_cd -- 币种代码
    ,mgmt_org_id -- 管理机构编号
    ,mdl_bank_acct_id -- 中间行账户编号
    ,mdl_bank_name -- 中间行名称
    ,mdl_bank_swift_cd -- 中间行SWIFT代码
    ,open_bank_acct_id -- 开户行账户编号
    ,open_bank_name -- 开户行名称
    ,open_bank_swift_cd -- 开户行SWIFT代码
    ,ghb_recv_bank_acct_name -- 本方收款行账户名称
    ,ghb_recv_bank_acct_swift_cd -- 本方收款行SWIFT代码
    ,pay_type_cd -- 支付类型代码
    ,dlvy_msg_cd -- 交割报文代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,org_id -- 机构编号
    ,bank_acct_id -- 银行账户编号
    ,bank_acct_name -- 银行账户名称
    ,curr_cd -- 币种代码
    ,mgmt_org_id -- 管理机构编号
    ,mdl_bank_acct_id -- 中间行账户编号
    ,mdl_bank_name -- 中间行名称
    ,mdl_bank_swift_cd -- 中间行SWIFT代码
    ,open_bank_acct_id -- 开户行账户编号
    ,open_bank_name -- 开户行名称
    ,open_bank_swift_cd -- 开户行SWIFT代码
    ,ghb_recv_bank_acct_name -- 本方收款行账户名称
    ,ghb_recv_bank_acct_swift_cd -- 本方收款行SWIFT代码
    ,pay_type_cd -- 支付类型代码
    ,dlvy_msg_cd -- 交割报文代码
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
    ,nvl(n.src_agt_id, o.src_agt_id) as src_agt_id -- 源协议编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.bank_acct_id, o.bank_acct_id) as bank_acct_id -- 银行账户编号
    ,nvl(n.bank_acct_name, o.bank_acct_name) as bank_acct_name -- 银行账户名称
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.mgmt_org_id, o.mgmt_org_id) as mgmt_org_id -- 管理机构编号
    ,nvl(n.mdl_bank_acct_id, o.mdl_bank_acct_id) as mdl_bank_acct_id -- 中间行账户编号
    ,nvl(n.mdl_bank_name, o.mdl_bank_name) as mdl_bank_name -- 中间行名称
    ,nvl(n.mdl_bank_swift_cd, o.mdl_bank_swift_cd) as mdl_bank_swift_cd -- 中间行SWIFT代码
    ,nvl(n.open_bank_acct_id, o.open_bank_acct_id) as open_bank_acct_id -- 开户行账户编号
    ,nvl(n.open_bank_name, o.open_bank_name) as open_bank_name -- 开户行名称
    ,nvl(n.open_bank_swift_cd, o.open_bank_swift_cd) as open_bank_swift_cd -- 开户行SWIFT代码
    ,nvl(n.ghb_recv_bank_acct_name, o.ghb_recv_bank_acct_name) as ghb_recv_bank_acct_name -- 本方收款行账户名称
    ,nvl(n.ghb_recv_bank_acct_swift_cd, o.ghb_recv_bank_acct_swift_cd) as ghb_recv_bank_acct_swift_cd -- 本方收款行SWIFT代码
    ,nvl(n.pay_type_cd, o.pay_type_cd) as pay_type_cd -- 支付类型代码
    ,nvl(n.dlvy_msg_cd, o.dlvy_msg_cd) as dlvy_msg_cd -- 交割报文代码
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
from ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_tm n
    full join (select * from ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.src_agt_id <> n.src_agt_id
        or o.org_id <> n.org_id
        or o.bank_acct_id <> n.bank_acct_id
        or o.bank_acct_name <> n.bank_acct_name
        or o.curr_cd <> n.curr_cd
        or o.mgmt_org_id <> n.mgmt_org_id
        or o.mdl_bank_acct_id <> n.mdl_bank_acct_id
        or o.mdl_bank_name <> n.mdl_bank_name
        or o.mdl_bank_swift_cd <> n.mdl_bank_swift_cd
        or o.open_bank_acct_id <> n.open_bank_acct_id
        or o.open_bank_name <> n.open_bank_name
        or o.open_bank_swift_cd <> n.open_bank_swift_cd
        or o.ghb_recv_bank_acct_name <> n.ghb_recv_bank_acct_name
        or o.ghb_recv_bank_acct_swift_cd <> n.ghb_recv_bank_acct_swift_cd
        or o.pay_type_cd <> n.pay_type_cd
        or o.dlvy_msg_cd <> n.dlvy_msg_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,org_id -- 机构编号
    ,bank_acct_id -- 银行账户编号
    ,bank_acct_name -- 银行账户名称
    ,curr_cd -- 币种代码
    ,mgmt_org_id -- 管理机构编号
    ,mdl_bank_acct_id -- 中间行账户编号
    ,mdl_bank_name -- 中间行名称
    ,mdl_bank_swift_cd -- 中间行SWIFT代码
    ,open_bank_acct_id -- 开户行账户编号
    ,open_bank_name -- 开户行名称
    ,open_bank_swift_cd -- 开户行SWIFT代码
    ,ghb_recv_bank_acct_name -- 本方收款行账户名称
    ,ghb_recv_bank_acct_swift_cd -- 本方收款行SWIFT代码
    ,pay_type_cd -- 支付类型代码
    ,dlvy_msg_cd -- 交割报文代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,org_id -- 机构编号
    ,bank_acct_id -- 银行账户编号
    ,bank_acct_name -- 银行账户名称
    ,curr_cd -- 币种代码
    ,mgmt_org_id -- 管理机构编号
    ,mdl_bank_acct_id -- 中间行账户编号
    ,mdl_bank_name -- 中间行名称
    ,mdl_bank_swift_cd -- 中间行SWIFT代码
    ,open_bank_acct_id -- 开户行账户编号
    ,open_bank_name -- 开户行名称
    ,open_bank_swift_cd -- 开户行SWIFT代码
    ,ghb_recv_bank_acct_name -- 本方收款行账户名称
    ,ghb_recv_bank_acct_swift_cd -- 本方收款行SWIFT代码
    ,pay_type_cd -- 支付类型代码
    ,dlvy_msg_cd -- 交割报文代码
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
    ,o.src_agt_id -- 源协议编号
    ,o.org_id -- 机构编号
    ,o.bank_acct_id -- 银行账户编号
    ,o.bank_acct_name -- 银行账户名称
    ,o.curr_cd -- 币种代码
    ,o.mgmt_org_id -- 管理机构编号
    ,o.mdl_bank_acct_id -- 中间行账户编号
    ,o.mdl_bank_name -- 中间行名称
    ,o.mdl_bank_swift_cd -- 中间行SWIFT代码
    ,o.open_bank_acct_id -- 开户行账户编号
    ,o.open_bank_name -- 开户行名称
    ,o.open_bank_swift_cd -- 开户行SWIFT代码
    ,o.ghb_recv_bank_acct_name -- 本方收款行账户名称
    ,o.ghb_recv_bank_acct_swift_cd -- 本方收款行SWIFT代码
    ,o.pay_type_cd -- 支付类型代码
    ,o.dlvy_msg_cd -- 交割报文代码
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
from ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_bk o
    left join ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_cl d
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
--truncate table ${iml_schema}.agt_ibank_cntpty_acct_info_h;
--alter table ${iml_schema}.agt_ibank_cntpty_acct_info_h truncate partition for ('ibmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_ibank_cntpty_acct_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ibmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_ibank_cntpty_acct_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_ibank_cntpty_acct_info_h modify partition p_ibmsf1 
add subpartition p_ibmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_ibank_cntpty_acct_info_h exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_cl;
alter table ${iml_schema}.agt_ibank_cntpty_acct_info_h exchange subpartition p_ibmsf1_20991231 with table ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ibank_cntpty_acct_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_tm purge;
drop table ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_op purge;
drop table ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_ibank_cntpty_acct_info_h_ibmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ibank_cntpty_acct_info_h', partname => 'p_ibmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
