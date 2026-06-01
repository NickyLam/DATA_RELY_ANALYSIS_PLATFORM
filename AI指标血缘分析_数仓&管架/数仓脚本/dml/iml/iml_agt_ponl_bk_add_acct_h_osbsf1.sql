/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ponl_bk_add_acct_h_osbsf1
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
alter table ${iml_schema}.agt_ponl_bk_add_acct_h add partition p_osbsf1 values ('osbsf1')(
        subpartition p_osbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_osbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ponl_bk_add_acct_h partition for ('osbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_tm purge;
drop table ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_op purge;
drop table ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,acct_name -- 账户名称
    ,curr_cd -- 币种代码
    ,open_prvlg_flg_comb -- 开通权限标志组合
    ,acct_in_tm -- 账户挂入时间
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_org_name -- 开户机构名称
    ,add_org_id -- 加挂机构编号
    ,add_org_name -- 加挂机构名称
    ,acct_status_cd -- 账户状态代码
    ,acct_alias -- 账户别名
    ,sign_way_cd -- 签约方式代码
    ,sign_chn_cd -- 签约渠道代码
    ,acct_pause_rs_descb -- 账户暂停原因描述
    ,co_card_type_cd -- 合作卡类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ponl_bk_add_acct_h partition for ('osbsf1')
where 0=1
;

create table ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ponl_bk_add_acct_h partition for ('osbsf1') where 0=1;

create table ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ponl_bk_add_acct_h partition for ('osbsf1') where 0=1;

-- 3.1 get new data into table
-- osbs_pbs_account_inf-1
insert into ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,acct_name -- 账户名称
    ,curr_cd -- 币种代码
    ,open_prvlg_flg_comb -- 开通权限标志组合
    ,acct_in_tm -- 账户挂入时间
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_org_name -- 开户机构名称
    ,add_org_id -- 加挂机构编号
    ,add_org_name -- 加挂机构名称
    ,acct_status_cd -- 账户状态代码
    ,acct_alias -- 账户别名
    ,sign_way_cd -- 签约方式代码
    ,sign_chn_cd -- 签约渠道代码
    ,acct_pause_rs_descb -- 账户暂停原因描述
    ,co_card_type_cd -- 合作卡类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '140010'||P1.PAI_ACCNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.PAI_ECIFNO -- 客户编号
    ,P1.PAI_ACCNO -- 账户编号
    ,NVL(P1.PAI_ACCTYPE,'-') -- 账户类型代码
    ,P1.PAI_ACCNAME -- 账户名称
    ,NVL(P1.PAI_CURRENCY,'-') -- 币种代码
    ,P1.PAI_AUTHORIZATION -- 开通权限标志组合
    ,${iml_schema}.timeformat_min(p1.PAI_OPENDATE) -- 账户挂入时间
    ,P1.PAI_OPENNODE -- 开户机构编号
    ,P1.PAI_OPENBRANCH -- 开户机构名称
    ,P1.PAI_ADDNODE -- 加挂机构编号
    ,P1.PAI_ADDBRANCH -- 加挂机构名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PAI_STATE END -- 账户状态代码
    ,P1.PAI_ACCALIAS -- 账户别名
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.PAI_SIGNWAY END -- 签约方式代码
    ,nvl(trim(P1.PAI_SIGNCHANNEL),'-')  -- 签约渠道代码
    ,P1.PAI_PAUSERREMARK -- 账户暂停原因描述
    ,decode(P1.PAI_CARDTYPE,'904010100058','35','904010100062','39',nvl(trim(P1.PAI_CARDTYPE),'99'))  -- 合作卡类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'osbs_pbs_account_inf' -- 源表名称
    ,'osbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.osbs_pbs_account_inf p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PAI_STATE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'OSBS'
        AND R1.SRC_TAB_EN_NAME= 'OSBS_PBS_ACCOUNT_INF'
        AND R1.SRC_FIELD_EN_NAME= 'PAI_STATE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_PONL_BK_ADD_ACCT_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ACCT_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PAI_SIGNWAY = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'OSBS'
        AND R2.SRC_TAB_EN_NAME= 'OSBS_PBS_ACCOUNT_INF'
        AND R2.SRC_FIELD_EN_NAME= 'PAI_SIGNWAY'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_PONL_BK_ADD_ACCT_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'SIGN_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,acct_name -- 账户名称
    ,curr_cd -- 币种代码
    ,open_prvlg_flg_comb -- 开通权限标志组合
    ,acct_in_tm -- 账户挂入时间
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_org_name -- 开户机构名称
    ,add_org_id -- 加挂机构编号
    ,add_org_name -- 加挂机构名称
    ,acct_status_cd -- 账户状态代码
    ,acct_alias -- 账户别名
    ,sign_way_cd -- 签约方式代码
    ,sign_chn_cd -- 签约渠道代码
    ,acct_pause_rs_descb -- 账户暂停原因描述
    ,co_card_type_cd -- 合作卡类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,acct_name -- 账户名称
    ,curr_cd -- 币种代码
    ,open_prvlg_flg_comb -- 开通权限标志组合
    ,acct_in_tm -- 账户挂入时间
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_org_name -- 开户机构名称
    ,add_org_id -- 加挂机构编号
    ,add_org_name -- 加挂机构名称
    ,acct_status_cd -- 账户状态代码
    ,acct_alias -- 账户别名
    ,sign_way_cd -- 签约方式代码
    ,sign_chn_cd -- 签约渠道代码
    ,acct_pause_rs_descb -- 账户暂停原因描述
    ,co_card_type_cd -- 合作卡类型代码
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
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.open_prvlg_flg_comb, o.open_prvlg_flg_comb) as open_prvlg_flg_comb -- 开通权限标志组合
    ,nvl(n.acct_in_tm, o.acct_in_tm) as acct_in_tm -- 账户挂入时间
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.open_acct_org_name, o.open_acct_org_name) as open_acct_org_name -- 开户机构名称
    ,nvl(n.add_org_id, o.add_org_id) as add_org_id -- 加挂机构编号
    ,nvl(n.add_org_name, o.add_org_name) as add_org_name -- 加挂机构名称
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.acct_alias, o.acct_alias) as acct_alias -- 账户别名
    ,nvl(n.sign_way_cd, o.sign_way_cd) as sign_way_cd -- 签约方式代码
    ,nvl(n.sign_chn_cd, o.sign_chn_cd) as sign_chn_cd -- 签约渠道代码
    ,nvl(n.acct_pause_rs_descb, o.acct_pause_rs_descb) as acct_pause_rs_descb -- 账户暂停原因描述
    ,nvl(n.co_card_type_cd, o.co_card_type_cd) as co_card_type_cd -- 合作卡类型代码
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cust_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cust_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cust_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_tm n
    full join (select * from ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.cust_id = n.cust_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.cust_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.cust_id is null
    )
    or (
        o.acct_id <> n.acct_id
        or o.acct_type_cd <> n.acct_type_cd
        or o.acct_name <> n.acct_name
        or o.curr_cd <> n.curr_cd
        or o.open_prvlg_flg_comb <> n.open_prvlg_flg_comb
        or o.acct_in_tm <> n.acct_in_tm
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.open_acct_org_name <> n.open_acct_org_name
        or o.add_org_id <> n.add_org_id
        or o.add_org_name <> n.add_org_name
        or o.acct_status_cd <> n.acct_status_cd
        or o.acct_alias <> n.acct_alias
        or o.sign_way_cd <> n.sign_way_cd
        or o.sign_chn_cd <> n.sign_chn_cd
        or o.acct_pause_rs_descb <> n.acct_pause_rs_descb
        or o.co_card_type_cd <> n.co_card_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,acct_name -- 账户名称
    ,curr_cd -- 币种代码
    ,open_prvlg_flg_comb -- 开通权限标志组合
    ,acct_in_tm -- 账户挂入时间
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_org_name -- 开户机构名称
    ,add_org_id -- 加挂机构编号
    ,add_org_name -- 加挂机构名称
    ,acct_status_cd -- 账户状态代码
    ,acct_alias -- 账户别名
    ,sign_way_cd -- 签约方式代码
    ,sign_chn_cd -- 签约渠道代码
    ,acct_pause_rs_descb -- 账户暂停原因描述
    ,co_card_type_cd -- 合作卡类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,acct_name -- 账户名称
    ,curr_cd -- 币种代码
    ,open_prvlg_flg_comb -- 开通权限标志组合
    ,acct_in_tm -- 账户挂入时间
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_org_name -- 开户机构名称
    ,add_org_id -- 加挂机构编号
    ,add_org_name -- 加挂机构名称
    ,acct_status_cd -- 账户状态代码
    ,acct_alias -- 账户别名
    ,sign_way_cd -- 签约方式代码
    ,sign_chn_cd -- 签约渠道代码
    ,acct_pause_rs_descb -- 账户暂停原因描述
    ,co_card_type_cd -- 合作卡类型代码
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
    ,o.cust_id -- 客户编号
    ,o.acct_id -- 账户编号
    ,o.acct_type_cd -- 账户类型代码
    ,o.acct_name -- 账户名称
    ,o.curr_cd -- 币种代码
    ,o.open_prvlg_flg_comb -- 开通权限标志组合
    ,o.acct_in_tm -- 账户挂入时间
    ,o.open_acct_org_id -- 开户机构编号
    ,o.open_acct_org_name -- 开户机构名称
    ,o.add_org_id -- 加挂机构编号
    ,o.add_org_name -- 加挂机构名称
    ,o.acct_status_cd -- 账户状态代码
    ,o.acct_alias -- 账户别名
    ,o.sign_way_cd -- 签约方式代码
    ,o.sign_chn_cd -- 签约渠道代码
    ,o.acct_pause_rs_descb -- 账户暂停原因描述
    ,o.co_card_type_cd -- 合作卡类型代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_bk o
    left join ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.cust_id = n.cust_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_cl d
        on
            o.agt_id = d.agt_id
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
--truncate table ${iml_schema}.agt_ponl_bk_add_acct_h;
alter table ${iml_schema}.agt_ponl_bk_add_acct_h truncate partition for ('osbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_ponl_bk_add_acct_h exchange subpartition p_osbsf1_19000101 with table ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_cl;
alter table ${iml_schema}.agt_ponl_bk_add_acct_h exchange subpartition p_osbsf1_20991231 with table ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ponl_bk_add_acct_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_tm purge;
drop table ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_op purge;
drop table ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_ponl_bk_add_acct_h_osbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ponl_bk_add_acct_h', partname => 'p_osbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
