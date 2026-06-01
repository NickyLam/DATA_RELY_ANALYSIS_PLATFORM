7/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ifs_acct_ifcsf1
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
drop table ${iml_schema}.agt_ifs_acct_ifcsf1_tm purge;
drop table ${iml_schema}.agt_ifs_acct_ifcsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_ifs_acct add partition p_ifcsf1 values ('ifcsf1')(
        subpartition p_ifcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_ifs_acct modify partition p_ifcsf1
    add subpartition p_ifcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ifs_acct_ifcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ifs_acct partition for ('ifcsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ifs_acct_ifcsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,acct_type_cd -- 账户类型代码
    ,open_acct_chn_cd -- 开户渠道代码
    ,open_acct_dt -- 开户日期
    ,acct_status_cd -- 账户状态代码
    ,froz_status_cd -- 冻结状态代码
    ,stop_pay_status_cd -- 止付状态代码
    ,acpt_pay_flg_cd -- 收付标志代码
    ,sleep_acct_flg -- 睡眠户标志
    ,dormt_acct_flg -- 不动户标志
    ,acct_usage_cd -- 账户用途代码
    ,open_acct_flow_id -- 开户流水编号
    ,acct_kind_cd -- 账户种类代码
    ,open_acct_org_id -- 开户机构编号
    ,clos_acct_dt -- 销户日期
    ,clos_acct_tm -- 销户时间
    ,clos_acct_flow_num -- 销户流水号
    ,final_sub_acct_seq_num -- 最后子户序号
    ,bind_we_acct_id -- 绑定微众账户编号
    ,final_activ_acct_dt -- 最后动户日期
    ,open_acct_cmplt_tm -- 开户完成时间
    ,sync_status_cd -- 同步状态代码
    ,sav_type_cd -- 储种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ifs_acct
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_ifs_acct_ifcsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_ifs_acct partition for ('ifcsf1') where 0=1;

-- 2.1 insert data to tm table
-- ifcs_dep_acct_info-
insert into ${iml_schema}.agt_ifs_acct_ifcsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,acct_type_cd -- 账户类型代码
    ,open_acct_chn_cd -- 开户渠道代码
    ,open_acct_dt -- 开户日期
    ,acct_status_cd -- 账户状态代码
    ,froz_status_cd -- 冻结状态代码
    ,stop_pay_status_cd -- 止付状态代码
    ,acpt_pay_flg_cd -- 收付标志代码
    ,sleep_acct_flg -- 睡眠户标志
    ,dormt_acct_flg -- 不动户标志
    ,acct_usage_cd -- 账户用途代码
    ,open_acct_flow_id -- 开户流水编号
    ,acct_kind_cd -- 账户种类代码
    ,open_acct_org_id -- 开户机构编号
    ,clos_acct_dt -- 销户日期
    ,clos_acct_tm -- 销户时间
    ,clos_acct_flow_num -- 销户流水号
    ,final_sub_acct_seq_num -- 最后子户序号
    ,bind_we_acct_id -- 绑定微众账户编号
    ,final_activ_acct_dt -- 最后动户日期
    ,open_acct_cmplt_tm -- 开户完成时间
    ,sync_status_cd -- 同步状态代码
    ,sav_type_cd -- 储种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120015'||P1.ACCT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ACCT_ID -- 账户编号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.CUST_ID -- 客户编号
    ,P1.ACCT_TYPE_CD -- 账户类型代码
    ,nvl(trim(P1.OPEN_ACCT_CHN_CD),'-')  -- 开户渠道代码
    ,${iml_schema}.dateformat_min(P1.OPEN_ACCT_DT) -- 开户日期
    ,decode(P1.ACCT_STATUS_CD,'0','C','1','A','-') -- 账户状态代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.FROZ_STATUS END -- 冻结状态代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.STPAY_STATUS_CD END -- 止付状态代码
    ,P1.ACPT_PAY_STATUS -- 收付标志代码
    ,P1.SLEEP_ACCT_FLG -- 睡眠户标志
    ,P1.DORMT_ACCT_FLG -- 不动户标志
    ,P1.ACCT_USAGE_CD -- 账户用途代码
    ,P1.OPEN_ACCT_FLOW_NUM -- 开户流水编号
    ,P1.ACCT_KIND_CD -- 账户种类代码
    ,P1.OPEN_ACCT_ORG_ID -- 开户机构编号
    ,${iml_schema}.dateformat_max(P1.CLOSE_ACCT_DT) -- 销户日期
    ,to_timestamp(trim(P1.CLOSE_ACCT_TI),'yyyymmdd hh24:mi:ss.ff6') -- 销户时间
    ,P1.CLOSE_ACCT_FLOW_NUM -- 销户流水号
    ,P1.LAST_SUB_ID -- 最后子户序号
    ,P1.BIND_ACCT_ID -- 绑定微众账户编号
    ,${iml_schema}.dateformat_min(P1.LAST_ACTIV_ACCT_DT) -- 最后动户日期
    ,to_timestamp(trim(P1.OPEN_ACCT_TM),'yyyymmddhh24missff6') -- 开户完成时间
    ,P1.SYNC_STATUS_CD -- 同步状态代码
    ,P1.DPS_TYPE_CD -- 储种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifcs_dep_acct_info' -- 源表名称
    ,'ifcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifcs_dep_acct_info p1
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.FROZ_STATUS = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'IFCS'
        AND R4.SRC_TAB_EN_NAME= 'IFCS_DEP_ACCT_INFO'
        AND R4.SRC_FIELD_EN_NAME= 'FROZ_STATUS'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_IFS_ACCT'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'FROZ_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.STPAY_STATUS_CD = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'IFCS'
        AND R5.SRC_TAB_EN_NAME= 'IFCS_DEP_ACCT_INFO'
        AND R5.SRC_FIELD_EN_NAME= 'STPAY_STATUS_CD'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_IFS_ACCT'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'STOP_PAY_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ifs_acct_ifcsf1_tm 
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_ifs_acct_ifcsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,acct_type_cd -- 账户类型代码
    ,open_acct_chn_cd -- 开户渠道代码
    ,open_acct_dt -- 开户日期
    ,acct_status_cd -- 账户状态代码
    ,froz_status_cd -- 冻结状态代码
    ,stop_pay_status_cd -- 止付状态代码
    ,acpt_pay_flg_cd -- 收付标志代码
    ,sleep_acct_flg -- 睡眠户标志
    ,dormt_acct_flg -- 不动户标志
    ,acct_usage_cd -- 账户用途代码
    ,open_acct_flow_id -- 开户流水编号
    ,acct_kind_cd -- 账户种类代码
    ,open_acct_org_id -- 开户机构编号
    ,clos_acct_dt -- 销户日期
    ,clos_acct_tm -- 销户时间
    ,clos_acct_flow_num -- 销户流水号
    ,final_sub_acct_seq_num -- 最后子户序号
    ,bind_we_acct_id -- 绑定微众账户编号
    ,final_activ_acct_dt -- 最后动户日期
    ,open_acct_cmplt_tm -- 开户完成时间
    ,sync_status_cd -- 同步状态代码
    ,sav_type_cd -- 储种代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.open_acct_chn_cd, o.open_acct_chn_cd) as open_acct_chn_cd -- 开户渠道代码
    ,nvl(n.open_acct_dt, o.open_acct_dt) as open_acct_dt -- 开户日期
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.froz_status_cd, o.froz_status_cd) as froz_status_cd -- 冻结状态代码
    ,nvl(n.stop_pay_status_cd, o.stop_pay_status_cd) as stop_pay_status_cd -- 止付状态代码
    ,nvl(n.acpt_pay_flg_cd, o.acpt_pay_flg_cd) as acpt_pay_flg_cd -- 收付标志代码
    ,nvl(n.sleep_acct_flg, o.sleep_acct_flg) as sleep_acct_flg -- 睡眠户标志
    ,nvl(n.dormt_acct_flg, o.dormt_acct_flg) as dormt_acct_flg -- 不动户标志
    ,nvl(n.acct_usage_cd, o.acct_usage_cd) as acct_usage_cd -- 账户用途代码
    ,nvl(n.open_acct_flow_id, o.open_acct_flow_id) as open_acct_flow_id -- 开户流水编号
    ,nvl(n.acct_kind_cd, o.acct_kind_cd) as acct_kind_cd -- 账户种类代码
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.clos_acct_dt, o.clos_acct_dt) as clos_acct_dt -- 销户日期
    ,nvl(n.clos_acct_tm, o.clos_acct_tm) as clos_acct_tm -- 销户时间
    ,nvl(n.clos_acct_flow_num, o.clos_acct_flow_num) as clos_acct_flow_num -- 销户流水号
    ,nvl(n.final_sub_acct_seq_num, o.final_sub_acct_seq_num) as final_sub_acct_seq_num -- 最后子户序号
    ,nvl(n.bind_we_acct_id, o.bind_we_acct_id) as bind_we_acct_id -- 绑定微众账户编号
    ,nvl(n.final_activ_acct_dt, o.final_activ_acct_dt) as final_activ_acct_dt -- 最后动户日期
    ,nvl(n.open_acct_cmplt_tm, o.open_acct_cmplt_tm) as open_acct_cmplt_tm -- 开户完成时间
    ,nvl(n.sync_status_cd, o.sync_status_cd) as sync_status_cd -- 同步状态代码
    ,nvl(n.sav_type_cd, o.sav_type_cd) as sav_type_cd -- 储种代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.acct_id <> n.acct_id
                or o.acct_name <> n.acct_name
                or o.cust_id <> n.cust_id
                or o.acct_type_cd <> n.acct_type_cd
                or o.open_acct_chn_cd <> n.open_acct_chn_cd
                or o.open_acct_dt <> n.open_acct_dt
                or o.acct_status_cd <> n.acct_status_cd
                or o.froz_status_cd <> n.froz_status_cd
                or o.stop_pay_status_cd <> n.stop_pay_status_cd
                or o.acpt_pay_flg_cd <> n.acpt_pay_flg_cd
                or o.sleep_acct_flg <> n.sleep_acct_flg
                or o.dormt_acct_flg <> n.dormt_acct_flg
                or o.acct_usage_cd <> n.acct_usage_cd
                or o.open_acct_flow_id <> n.open_acct_flow_id
                or o.acct_kind_cd <> n.acct_kind_cd
                or o.open_acct_org_id <> n.open_acct_org_id
                or o.clos_acct_dt <> n.clos_acct_dt
                or o.clos_acct_tm <> n.clos_acct_tm
                or o.clos_acct_flow_num <> n.clos_acct_flow_num
                or o.final_sub_acct_seq_num <> n.final_sub_acct_seq_num
                or o.bind_we_acct_id <> n.bind_we_acct_id
                or o.final_activ_acct_dt <> n.final_activ_acct_dt
                or o.open_acct_cmplt_tm <> n.open_acct_cmplt_tm
                or o.sync_status_cd <> n.sync_status_cd
                or o.sav_type_cd <> n.sav_type_cd
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
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
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ifs_acct_ifcsf1_tm n
    full join ${iml_schema}.agt_ifs_acct_ifcsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_ifs_acct truncate partition for ('ifcsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_ifs_acct exchange subpartition p_ifcsf1_${batch_date} with table ${iml_schema}.agt_ifs_acct_ifcsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ifs_acct drop subpartition p_ifcsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ifs_acct to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_ifs_acct_ifcsf1_tm purge;
drop table ${iml_schema}.agt_ifs_acct_ifcsf1_ex purge;
drop table ${iml_schema}.agt_ifs_acct_ifcsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ifs_acct', partname => 'p_ifcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);