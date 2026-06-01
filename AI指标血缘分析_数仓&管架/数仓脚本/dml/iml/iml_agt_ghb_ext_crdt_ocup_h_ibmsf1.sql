/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ghb_ext_crdt_ocup_h_ibmsf1
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
alter table ${iml_schema}.agt_ghb_ext_crdt_ocup_h add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ibmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ghb_ext_crdt_ocup_h partition for ('ibmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_tm purge;
drop table ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_op purge;
drop table ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,apv_form_num -- 审批单号
    ,tran_odd_no -- 交易单号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,acct_acctnt_cls_cd -- 账户会计分类代码
    ,acct_b_cate_cd -- 账簿类别代码
    ,crdt_side_cust_id -- 授信方客户编号
    ,crdt_side_name -- 授信方名称
    ,lmt_cont_id -- 额度合同编号
    ,occu_lmt -- 已占用额度
    ,ocup_surp_lmt -- 占用剩余额度
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ghb_ext_crdt_ocup_h partition for ('ibmsf1')
where 0=1
;

create table ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ghb_ext_crdt_ocup_h partition for ('ibmsf1') where 0=1;

create table ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ghb_ext_crdt_ocup_h partition for ('ibmsf1') where 0=1;

-- 3.1 get new data into table
-- ibms_ttrd_hx_credit_record-1
insert into ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,apv_form_num -- 审批单号
    ,tran_odd_no -- 交易单号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,acct_acctnt_cls_cd -- 账户会计分类代码
    ,acct_b_cate_cd -- 账簿类别代码
    ,crdt_side_cust_id -- 授信方客户编号
    ,crdt_side_name -- 授信方名称
    ,lmt_cont_id -- 额度合同编号
    ,occu_lmt -- 已占用额度
    ,ocup_surp_lmt -- 占用剩余额度
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '231038'||P1.ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ID -- 序列号
    ,P1.ORD_ID -- 审批单号
    ,P1.INTORDID -- 交易单号
    ,P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,P1.SECU_ACCID -- 内部券账户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.SECU_ACTGTYPE END -- 账户会计分类代码
    ,P1.CREDIT_SECU_TYPE -- 账簿类别代码
    ,P1.PARTY_ID -- 授信方客户编号
    ,P1.PARTY_NAME -- 授信方名称
    ,P1.REPLY_CODE -- 额度合同编号
    ,P1.OCCUPY_AMOUNT -- 已占用额度
    ,P1.REMAIN_AMOUNT -- 占用剩余额度
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_hx_credit_record' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_hx_credit_record p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.SECU_ACTGTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_HX_CREDIT_RECORD'
        AND R1.SRC_FIELD_EN_NAME= 'SECU_ACTGTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_GHB_EXT_CRDT_OCUP_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ACCT_ACCTNT_CLS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_tm 
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
        into ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,apv_form_num -- 审批单号
    ,tran_odd_no -- 交易单号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,acct_acctnt_cls_cd -- 账户会计分类代码
    ,acct_b_cate_cd -- 账簿类别代码
    ,crdt_side_cust_id -- 授信方客户编号
    ,crdt_side_name -- 授信方名称
    ,lmt_cont_id -- 额度合同编号
    ,occu_lmt -- 已占用额度
    ,ocup_surp_lmt -- 占用剩余额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,apv_form_num -- 审批单号
    ,tran_odd_no -- 交易单号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,acct_acctnt_cls_cd -- 账户会计分类代码
    ,acct_b_cate_cd -- 账簿类别代码
    ,crdt_side_cust_id -- 授信方客户编号
    ,crdt_side_name -- 授信方名称
    ,lmt_cont_id -- 额度合同编号
    ,occu_lmt -- 已占用额度
    ,ocup_surp_lmt -- 占用剩余额度
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
    ,nvl(n.ser_num, o.ser_num) as ser_num -- 序列号
    ,nvl(n.apv_form_num, o.apv_form_num) as apv_form_num -- 审批单号
    ,nvl(n.tran_odd_no, o.tran_odd_no) as tran_odd_no -- 交易单号
    ,nvl(n.fin_instm_id, o.fin_instm_id) as fin_instm_id -- 金融工具编号
    ,nvl(n.asset_type_id, o.asset_type_id) as asset_type_id -- 资产类型编号
    ,nvl(n.market_type_id, o.market_type_id) as market_type_id -- 市场类型编号
    ,nvl(n.intnal_vch_acct_id, o.intnal_vch_acct_id) as intnal_vch_acct_id -- 内部券账户编号
    ,nvl(n.acct_acctnt_cls_cd, o.acct_acctnt_cls_cd) as acct_acctnt_cls_cd -- 账户会计分类代码
    ,nvl(n.acct_b_cate_cd, o.acct_b_cate_cd) as acct_b_cate_cd -- 账簿类别代码
    ,nvl(n.crdt_side_cust_id, o.crdt_side_cust_id) as crdt_side_cust_id -- 授信方客户编号
    ,nvl(n.crdt_side_name, o.crdt_side_name) as crdt_side_name -- 授信方名称
    ,nvl(n.lmt_cont_id, o.lmt_cont_id) as lmt_cont_id -- 额度合同编号
    ,nvl(n.occu_lmt, o.occu_lmt) as occu_lmt -- 已占用额度
    ,nvl(n.ocup_surp_lmt, o.ocup_surp_lmt) as ocup_surp_lmt -- 占用剩余额度
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
from ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_tm n
    full join (select * from ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.ser_num <> n.ser_num
        or o.apv_form_num <> n.apv_form_num
        or o.tran_odd_no <> n.tran_odd_no
        or o.fin_instm_id <> n.fin_instm_id
        or o.asset_type_id <> n.asset_type_id
        or o.market_type_id <> n.market_type_id
        or o.intnal_vch_acct_id <> n.intnal_vch_acct_id
        or o.acct_acctnt_cls_cd <> n.acct_acctnt_cls_cd
        or o.acct_b_cate_cd <> n.acct_b_cate_cd
        or o.crdt_side_cust_id <> n.crdt_side_cust_id
        or o.crdt_side_name <> n.crdt_side_name
        or o.lmt_cont_id <> n.lmt_cont_id
        or o.occu_lmt <> n.occu_lmt
        or o.ocup_surp_lmt <> n.ocup_surp_lmt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,apv_form_num -- 审批单号
    ,tran_odd_no -- 交易单号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,acct_acctnt_cls_cd -- 账户会计分类代码
    ,acct_b_cate_cd -- 账簿类别代码
    ,crdt_side_cust_id -- 授信方客户编号
    ,crdt_side_name -- 授信方名称
    ,lmt_cont_id -- 额度合同编号
    ,occu_lmt -- 已占用额度
    ,ocup_surp_lmt -- 占用剩余额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,apv_form_num -- 审批单号
    ,tran_odd_no -- 交易单号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,acct_acctnt_cls_cd -- 账户会计分类代码
    ,acct_b_cate_cd -- 账簿类别代码
    ,crdt_side_cust_id -- 授信方客户编号
    ,crdt_side_name -- 授信方名称
    ,lmt_cont_id -- 额度合同编号
    ,occu_lmt -- 已占用额度
    ,ocup_surp_lmt -- 占用剩余额度
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
    ,o.ser_num -- 序列号
    ,o.apv_form_num -- 审批单号
    ,o.tran_odd_no -- 交易单号
    ,o.fin_instm_id -- 金融工具编号
    ,o.asset_type_id -- 资产类型编号
    ,o.market_type_id -- 市场类型编号
    ,o.intnal_vch_acct_id -- 内部券账户编号
    ,o.acct_acctnt_cls_cd -- 账户会计分类代码
    ,o.acct_b_cate_cd -- 账簿类别代码
    ,o.crdt_side_cust_id -- 授信方客户编号
    ,o.crdt_side_name -- 授信方名称
    ,o.lmt_cont_id -- 额度合同编号
    ,o.occu_lmt -- 已占用额度
    ,o.ocup_surp_lmt -- 占用剩余额度
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
from ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_bk o
    left join ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_cl d
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
--truncate table ${iml_schema}.agt_ghb_ext_crdt_ocup_h;
--alter table ${iml_schema}.agt_ghb_ext_crdt_ocup_h truncate partition for ('ibmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_ghb_ext_crdt_ocup_h') 
               and substr(subpartition_name,1,8)=upper('p_ibmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_ghb_ext_crdt_ocup_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_ghb_ext_crdt_ocup_h modify partition p_ibmsf1 
add subpartition p_ibmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_ghb_ext_crdt_ocup_h exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_cl;
alter table ${iml_schema}.agt_ghb_ext_crdt_ocup_h exchange subpartition p_ibmsf1_20991231 with table ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ghb_ext_crdt_ocup_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_tm purge;
drop table ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_op purge;
drop table ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_ghb_ext_crdt_ocup_h_ibmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ghb_ext_crdt_ocup_h', partname => 'p_ibmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
