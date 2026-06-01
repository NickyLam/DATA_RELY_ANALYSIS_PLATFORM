/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dep_acct_chn_lmt_info_h_ncbsf1
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
alter table ${iml_schema}.agt_dep_acct_chn_lmt_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_chn_lmt_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ctrl_id -- 控制编号
    ,ctrl_type_cd -- 控制类型代码
    ,ctrl_status_cd -- 控制状态代码
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,tran_ref_no -- 交易参考号
    ,tran_teller_id -- 交易柜员编号
    ,ova_flow_num -- 全局流水号
    ,lmt_lev_cd -- 限制级别代码
    ,tran_id -- 交易编号
    ,tran_timestamp -- 交易时间
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,lmt_acct_range_cd -- 限制账户范围代码
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,final_modif_dt -- 最后修改日期
    ,auth_teller_id -- 授权柜员编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,tran_org_id -- 交易机构编号
    ,unloss_tm -- 解挂时间
    ,unloss_teller_id -- 解挂柜员编号
    ,memo_descb -- 摘要描述
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_chn_lmt_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_chn_lmt_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_chn_lmt_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_channel_control-1
insert into ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ctrl_id -- 控制编号
    ,ctrl_type_cd -- 控制类型代码
    ,ctrl_status_cd -- 控制状态代码
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,tran_ref_no -- 交易参考号
    ,tran_teller_id -- 交易柜员编号
    ,ova_flow_num -- 全局流水号
    ,lmt_lev_cd -- 限制级别代码
    ,tran_id -- 交易编号
    ,tran_timestamp -- 交易时间
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,lmt_acct_range_cd -- 限制账户范围代码
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,final_modif_dt -- 最后修改日期
    ,auth_teller_id -- 授权柜员编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,tran_org_id -- 交易机构编号
    ,unloss_tm -- 解挂时间
    ,unloss_teller_id -- 解挂柜员编号
    ,memo_descb -- 摘要描述
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CONTROL_SEQ_NO -- 控制编号
    ,P1.CONTROL_TYPE -- 控制类型代码
    ,P1.CONTROL_STATUS -- 控制状态代码
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.REFERENCE -- 交易参考号
    ,P1.USER_ID -- 交易柜员编号
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,nvl(trim(P1.LIMIT_LEVEL),'-') -- 限制级别代码
    ,P1.PROGRAM_ID -- 交易编号
    ,${iml_schema}.timeformat_max2(P1.TRAN_TIMESTAMP) -- 交易时间
    ,P1.START_DATE -- 起始日期
    ,P1.END_DATE -- 到期日期
    ,nvl(trim(P1.RES_ACCT_RANGE),'-') -- 限制账户范围代码
    ,P1.CHANNEL -- 渠道编号
    ,${iml_schema}.timeformat_min(P1.START_DATE_TIME) -- 生效日期
    ,${iml_schema}.timeformat_min(P1.END_DATE_TIME) -- 失效日期
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,P1.LAST_CHANGE_USER_ID -- 最后修改柜员编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,${iml_schema}.timeformat_max2(P1.UNLOST_TIME) -- 解挂时间
    ,P1.OUT_SIGN_USER_ID -- 解挂柜员编号
    ,P1.NARRATIVE -- 摘要描述
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_channel_control' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_channel_control p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.base_acct_no = p8.base_acct_no
   and p8.base_acct_no like '0%'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,ctrl_id
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
        into ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ctrl_id -- 控制编号
    ,ctrl_type_cd -- 控制类型代码
    ,ctrl_status_cd -- 控制状态代码
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,tran_ref_no -- 交易参考号
    ,tran_teller_id -- 交易柜员编号
    ,ova_flow_num -- 全局流水号
    ,lmt_lev_cd -- 限制级别代码
    ,tran_id -- 交易编号
    ,tran_timestamp -- 交易时间
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,lmt_acct_range_cd -- 限制账户范围代码
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,final_modif_dt -- 最后修改日期
    ,auth_teller_id -- 授权柜员编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,tran_org_id -- 交易机构编号
    ,unloss_tm -- 解挂时间
    ,unloss_teller_id -- 解挂柜员编号
    ,memo_descb -- 摘要描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ctrl_id -- 控制编号
    ,ctrl_type_cd -- 控制类型代码
    ,ctrl_status_cd -- 控制状态代码
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,tran_ref_no -- 交易参考号
    ,tran_teller_id -- 交易柜员编号
    ,ova_flow_num -- 全局流水号
    ,lmt_lev_cd -- 限制级别代码
    ,tran_id -- 交易编号
    ,tran_timestamp -- 交易时间
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,lmt_acct_range_cd -- 限制账户范围代码
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,final_modif_dt -- 最后修改日期
    ,auth_teller_id -- 授权柜员编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,tran_org_id -- 交易机构编号
    ,unloss_tm -- 解挂时间
    ,unloss_teller_id -- 解挂柜员编号
    ,memo_descb -- 摘要描述
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
    ,nvl(n.ctrl_id, o.ctrl_id) as ctrl_id -- 控制编号
    ,nvl(n.ctrl_type_cd, o.ctrl_type_cd) as ctrl_type_cd -- 控制类型代码
    ,nvl(n.ctrl_status_cd, o.ctrl_status_cd) as ctrl_status_cd -- 控制状态代码
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.ova_flow_num, o.ova_flow_num) as ova_flow_num -- 全局流水号
    ,nvl(n.lmt_lev_cd, o.lmt_lev_cd) as lmt_lev_cd -- 限制级别代码
    ,nvl(n.tran_id, o.tran_id) as tran_id -- 交易编号
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间
    ,nvl(n.begin_dt, o.begin_dt) as begin_dt -- 起始日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.lmt_acct_range_cd, o.lmt_acct_range_cd) as lmt_acct_range_cd -- 限制账户范围代码
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,nvl(n.final_modif_teller_id, o.final_modif_teller_id) as final_modif_teller_id -- 最后修改柜员编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.unloss_tm, o.unloss_tm) as unloss_tm -- 解挂时间
    ,nvl(n.unloss_teller_id, o.unloss_teller_id) as unloss_teller_id -- 解挂柜员编号
    ,nvl(n.memo_descb, o.memo_descb) as memo_descb -- 摘要描述
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.ctrl_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.ctrl_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.ctrl_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.ctrl_id = n.ctrl_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.ctrl_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.ctrl_id is null
    )
    or (
        o.ctrl_type_cd <> n.ctrl_type_cd
        or o.ctrl_status_cd <> n.ctrl_status_cd
        or o.cust_acct_num <> n.cust_acct_num
        or o.cust_id <> n.cust_id
        or o.acct_id <> n.acct_id
        or o.tran_ref_no <> n.tran_ref_no
        or o.tran_teller_id <> n.tran_teller_id
        or o.ova_flow_num <> n.ova_flow_num
        or o.lmt_lev_cd <> n.lmt_lev_cd
        or o.tran_id <> n.tran_id
        or o.tran_timestamp <> n.tran_timestamp
        or o.begin_dt <> n.begin_dt
        or o.exp_dt <> n.exp_dt
        or o.lmt_acct_range_cd <> n.lmt_acct_range_cd
        or o.chn_id <> n.chn_id
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.final_modif_dt <> n.final_modif_dt
        or o.auth_teller_id <> n.auth_teller_id
        or o.final_modif_teller_id <> n.final_modif_teller_id
        or o.tran_org_id <> n.tran_org_id
        or o.unloss_tm <> n.unloss_tm
        or o.unloss_teller_id <> n.unloss_teller_id
        or o.memo_descb <> n.memo_descb
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ctrl_id -- 控制编号
    ,ctrl_type_cd -- 控制类型代码
    ,ctrl_status_cd -- 控制状态代码
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,tran_ref_no -- 交易参考号
    ,tran_teller_id -- 交易柜员编号
    ,ova_flow_num -- 全局流水号
    ,lmt_lev_cd -- 限制级别代码
    ,tran_id -- 交易编号
    ,tran_timestamp -- 交易时间
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,lmt_acct_range_cd -- 限制账户范围代码
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,final_modif_dt -- 最后修改日期
    ,auth_teller_id -- 授权柜员编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,tran_org_id -- 交易机构编号
    ,unloss_tm -- 解挂时间
    ,unloss_teller_id -- 解挂柜员编号
    ,memo_descb -- 摘要描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,ctrl_id -- 控制编号
    ,ctrl_type_cd -- 控制类型代码
    ,ctrl_status_cd -- 控制状态代码
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,tran_ref_no -- 交易参考号
    ,tran_teller_id -- 交易柜员编号
    ,ova_flow_num -- 全局流水号
    ,lmt_lev_cd -- 限制级别代码
    ,tran_id -- 交易编号
    ,tran_timestamp -- 交易时间
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,lmt_acct_range_cd -- 限制账户范围代码
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,final_modif_dt -- 最后修改日期
    ,auth_teller_id -- 授权柜员编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,tran_org_id -- 交易机构编号
    ,unloss_tm -- 解挂时间
    ,unloss_teller_id -- 解挂柜员编号
    ,memo_descb -- 摘要描述
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
    ,o.ctrl_id -- 控制编号
    ,o.ctrl_type_cd -- 控制类型代码
    ,o.ctrl_status_cd -- 控制状态代码
    ,o.cust_acct_num -- 客户账号
    ,o.cust_id -- 客户编号
    ,o.acct_id -- 账户编号
    ,o.tran_ref_no -- 交易参考号
    ,o.tran_teller_id -- 交易柜员编号
    ,o.ova_flow_num -- 全局流水号
    ,o.lmt_lev_cd -- 限制级别代码
    ,o.tran_id -- 交易编号
    ,o.tran_timestamp -- 交易时间
    ,o.begin_dt -- 起始日期
    ,o.exp_dt -- 到期日期
    ,o.lmt_acct_range_cd -- 限制账户范围代码
    ,o.chn_id -- 渠道编号
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.final_modif_dt -- 最后修改日期
    ,o.auth_teller_id -- 授权柜员编号
    ,o.final_modif_teller_id -- 最后修改柜员编号
    ,o.tran_org_id -- 交易机构编号
    ,o.unloss_tm -- 解挂时间
    ,o.unloss_teller_id -- 解挂柜员编号
    ,o.memo_descb -- 摘要描述
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
from ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.ctrl_id = n.ctrl_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.ctrl_id = d.ctrl_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_dep_acct_chn_lmt_info_h;
--alter table ${iml_schema}.agt_dep_acct_chn_lmt_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_dep_acct_chn_lmt_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_dep_acct_chn_lmt_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_dep_acct_chn_lmt_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_dep_acct_chn_lmt_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_dep_acct_chn_lmt_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dep_acct_chn_lmt_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_dep_acct_chn_lmt_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dep_acct_chn_lmt_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
