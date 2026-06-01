/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_exp_lc_h_isbsf1
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
alter table ${iml_schema}.agt_exp_lc_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_exp_lc_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_exp_lc_h partition for ('isbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_exp_lc_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_exp_lc_h_isbsf1_op purge;
drop table ${iml_schema}.agt_exp_lc_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_exp_lc_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_lc_id -- 内部信用证编号
    ,lc_id -- 信用证编号
    ,tran_name -- 交易名称
    ,teller_id -- 柜员编号
    ,lc_effect_dt -- 信用证生效日期
    ,lc_issue_dt -- 信用证开证日期
    ,lc_exp_dt -- 信用证到期日期
    ,cfm_dt -- 保兑日期
    ,advise_dt -- 通知日期
    ,issue_bank_name -- 开证行名称
    ,benefc_name -- 受益人名称
    ,cfm_way_cd -- 保兑方式代码
    ,exp_dt -- 出口日期
    ,tran_cmplt_site -- 交易完成地点
    ,lc_type_cd -- 信用证类型代码
    ,pre_advise_dt -- 预通知日期
    ,cty_cd -- 国家代码
    ,red_green_claus_flg -- 红绿条款标志
    ,cfm_pct -- 保兑百分比
    ,belong_org_id -- 所属机构编号
    ,tran_org_id -- 交易机构编号
    ,dom_lc_flg -- 国内信用证标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_exp_lc_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.agt_exp_lc_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_exp_lc_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.agt_exp_lc_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_exp_lc_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_led-1
insert into ${iml_schema}.agt_exp_lc_h_isbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_lc_id -- 内部信用证编号
    ,lc_id -- 信用证编号
    ,tran_name -- 交易名称
    ,teller_id -- 柜员编号
    ,lc_effect_dt -- 信用证生效日期
    ,lc_issue_dt -- 信用证开证日期
    ,lc_exp_dt -- 信用证到期日期
    ,cfm_dt -- 保兑日期
    ,advise_dt -- 通知日期
    ,issue_bank_name -- 开证行名称
    ,benefc_name -- 受益人名称
    ,cfm_way_cd -- 保兑方式代码
    ,exp_dt -- 出口日期
    ,tran_cmplt_site -- 交易完成地点
    ,lc_type_cd -- 信用证类型代码
    ,pre_advise_dt -- 预通知日期
    ,cty_cd -- 国家代码
    ,red_green_claus_flg -- 红绿条款标志
    ,cfm_pct -- 保兑百分比
    ,belong_org_id -- 所属机构编号
    ,tran_org_id -- 交易机构编号
    ,dom_lc_flg -- 国内信用证标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222307'||INR -- 协议编号
    ,'9999' -- 法人编号
    ,to_char(P1.INR) -- 内部信用证编号
    ,P1.OWNREF -- 信用证编号
    ,P1.NAM -- 交易名称
    ,P1.OWNUSR -- 柜员编号
    ,P1.CREDAT -- 信用证生效日期
    ,P1.OPNDAT -- 信用证开证日期
    ,P1.CLSDAT -- 信用证到期日期
    ,P1.CNFDAT -- 保兑日期
    ,P1.ADVDAT -- 通知日期
    ,P1.ISSNAM -- 开证行名称
    ,P1.BENNAM -- 受益人名称
    ,P1.CNFDET -- 保兑方式代码
    ,P1.EXPDAT -- 出口日期
    ,P1.EXPPLC -- 交易完成地点
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.LCRTYP END -- 信用证类型代码
    ,P1.PREADVDT -- 预通知日期
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.STACTY END -- 国家代码
    ,case when P1.REDCLSFLG='X' then '1' else '0' end -- 红绿条款标志
    ,P1.PARTCON -- 保兑百分比
    ,P1.BRANCHINR -- 所属机构编号
    ,P1.BCHKEYINR -- 交易机构编号
    ,P1.DFLG -- 国内信用证标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_led' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_led p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.LCRTYP = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ISBS'
        AND R1.SRC_TAB_EN_NAME= 'ISBS_LED'
        AND R1.SRC_FIELD_EN_NAME= 'LCRTYP'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_EXP_LC_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'LC_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.STACTY = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ISBS'
        AND R2.SRC_TAB_EN_NAME= 'ISBS_LED'
        AND R2.SRC_FIELD_EN_NAME= 'STACTY'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_EXP_LC_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CTY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_exp_lc_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_lc_id -- 内部信用证编号
    ,lc_id -- 信用证编号
    ,tran_name -- 交易名称
    ,teller_id -- 柜员编号
    ,lc_effect_dt -- 信用证生效日期
    ,lc_issue_dt -- 信用证开证日期
    ,lc_exp_dt -- 信用证到期日期
    ,cfm_dt -- 保兑日期
    ,advise_dt -- 通知日期
    ,issue_bank_name -- 开证行名称
    ,benefc_name -- 受益人名称
    ,cfm_way_cd -- 保兑方式代码
    ,exp_dt -- 出口日期
    ,tran_cmplt_site -- 交易完成地点
    ,lc_type_cd -- 信用证类型代码
    ,pre_advise_dt -- 预通知日期
    ,cty_cd -- 国家代码
    ,red_green_claus_flg -- 红绿条款标志
    ,cfm_pct -- 保兑百分比
    ,belong_org_id -- 所属机构编号
    ,tran_org_id -- 交易机构编号
    ,dom_lc_flg -- 国内信用证标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_exp_lc_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_lc_id -- 内部信用证编号
    ,lc_id -- 信用证编号
    ,tran_name -- 交易名称
    ,teller_id -- 柜员编号
    ,lc_effect_dt -- 信用证生效日期
    ,lc_issue_dt -- 信用证开证日期
    ,lc_exp_dt -- 信用证到期日期
    ,cfm_dt -- 保兑日期
    ,advise_dt -- 通知日期
    ,issue_bank_name -- 开证行名称
    ,benefc_name -- 受益人名称
    ,cfm_way_cd -- 保兑方式代码
    ,exp_dt -- 出口日期
    ,tran_cmplt_site -- 交易完成地点
    ,lc_type_cd -- 信用证类型代码
    ,pre_advise_dt -- 预通知日期
    ,cty_cd -- 国家代码
    ,red_green_claus_flg -- 红绿条款标志
    ,cfm_pct -- 保兑百分比
    ,belong_org_id -- 所属机构编号
    ,tran_org_id -- 交易机构编号
    ,dom_lc_flg -- 国内信用证标志
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
    ,nvl(n.intnal_lc_id, o.intnal_lc_id) as intnal_lc_id -- 内部信用证编号
    ,nvl(n.lc_id, o.lc_id) as lc_id -- 信用证编号
    ,nvl(n.tran_name, o.tran_name) as tran_name -- 交易名称
    ,nvl(n.teller_id, o.teller_id) as teller_id -- 柜员编号
    ,nvl(n.lc_effect_dt, o.lc_effect_dt) as lc_effect_dt -- 信用证生效日期
    ,nvl(n.lc_issue_dt, o.lc_issue_dt) as lc_issue_dt -- 信用证开证日期
    ,nvl(n.lc_exp_dt, o.lc_exp_dt) as lc_exp_dt -- 信用证到期日期
    ,nvl(n.cfm_dt, o.cfm_dt) as cfm_dt -- 保兑日期
    ,nvl(n.advise_dt, o.advise_dt) as advise_dt -- 通知日期
    ,nvl(n.issue_bank_name, o.issue_bank_name) as issue_bank_name -- 开证行名称
    ,nvl(n.benefc_name, o.benefc_name) as benefc_name -- 受益人名称
    ,nvl(n.cfm_way_cd, o.cfm_way_cd) as cfm_way_cd -- 保兑方式代码
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 出口日期
    ,nvl(n.tran_cmplt_site, o.tran_cmplt_site) as tran_cmplt_site -- 交易完成地点
    ,nvl(n.lc_type_cd, o.lc_type_cd) as lc_type_cd -- 信用证类型代码
    ,nvl(n.pre_advise_dt, o.pre_advise_dt) as pre_advise_dt -- 预通知日期
    ,nvl(n.cty_cd, o.cty_cd) as cty_cd -- 国家代码
    ,nvl(n.red_green_claus_flg, o.red_green_claus_flg) as red_green_claus_flg -- 红绿条款标志
    ,nvl(n.cfm_pct, o.cfm_pct) as cfm_pct -- 保兑百分比
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.dom_lc_flg, o.dom_lc_flg) as dom_lc_flg -- 国内信用证标志
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
from ${iml_schema}.agt_exp_lc_h_isbsf1_tm n
    full join (select * from ${iml_schema}.agt_exp_lc_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.intnal_lc_id <> n.intnal_lc_id
        or o.lc_id <> n.lc_id
        or o.tran_name <> n.tran_name
        or o.teller_id <> n.teller_id
        or o.lc_effect_dt <> n.lc_effect_dt
        or o.lc_issue_dt <> n.lc_issue_dt
        or o.lc_exp_dt <> n.lc_exp_dt
        or o.cfm_dt <> n.cfm_dt
        or o.advise_dt <> n.advise_dt
        or o.issue_bank_name <> n.issue_bank_name
        or o.benefc_name <> n.benefc_name
        or o.cfm_way_cd <> n.cfm_way_cd
        or o.exp_dt <> n.exp_dt
        or o.tran_cmplt_site <> n.tran_cmplt_site
        or o.lc_type_cd <> n.lc_type_cd
        or o.pre_advise_dt <> n.pre_advise_dt
        or o.cty_cd <> n.cty_cd
        or o.red_green_claus_flg <> n.red_green_claus_flg
        or o.cfm_pct <> n.cfm_pct
        or o.belong_org_id <> n.belong_org_id
        or o.tran_org_id <> n.tran_org_id
        or o.dom_lc_flg <> n.dom_lc_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_exp_lc_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_lc_id -- 内部信用证编号
    ,lc_id -- 信用证编号
    ,tran_name -- 交易名称
    ,teller_id -- 柜员编号
    ,lc_effect_dt -- 信用证生效日期
    ,lc_issue_dt -- 信用证开证日期
    ,lc_exp_dt -- 信用证到期日期
    ,cfm_dt -- 保兑日期
    ,advise_dt -- 通知日期
    ,issue_bank_name -- 开证行名称
    ,benefc_name -- 受益人名称
    ,cfm_way_cd -- 保兑方式代码
    ,exp_dt -- 出口日期
    ,tran_cmplt_site -- 交易完成地点
    ,lc_type_cd -- 信用证类型代码
    ,pre_advise_dt -- 预通知日期
    ,cty_cd -- 国家代码
    ,red_green_claus_flg -- 红绿条款标志
    ,cfm_pct -- 保兑百分比
    ,belong_org_id -- 所属机构编号
    ,tran_org_id -- 交易机构编号
    ,dom_lc_flg -- 国内信用证标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_exp_lc_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_lc_id -- 内部信用证编号
    ,lc_id -- 信用证编号
    ,tran_name -- 交易名称
    ,teller_id -- 柜员编号
    ,lc_effect_dt -- 信用证生效日期
    ,lc_issue_dt -- 信用证开证日期
    ,lc_exp_dt -- 信用证到期日期
    ,cfm_dt -- 保兑日期
    ,advise_dt -- 通知日期
    ,issue_bank_name -- 开证行名称
    ,benefc_name -- 受益人名称
    ,cfm_way_cd -- 保兑方式代码
    ,exp_dt -- 出口日期
    ,tran_cmplt_site -- 交易完成地点
    ,lc_type_cd -- 信用证类型代码
    ,pre_advise_dt -- 预通知日期
    ,cty_cd -- 国家代码
    ,red_green_claus_flg -- 红绿条款标志
    ,cfm_pct -- 保兑百分比
    ,belong_org_id -- 所属机构编号
    ,tran_org_id -- 交易机构编号
    ,dom_lc_flg -- 国内信用证标志
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
    ,o.intnal_lc_id -- 内部信用证编号
    ,o.lc_id -- 信用证编号
    ,o.tran_name -- 交易名称
    ,o.teller_id -- 柜员编号
    ,o.lc_effect_dt -- 信用证生效日期
    ,o.lc_issue_dt -- 信用证开证日期
    ,o.lc_exp_dt -- 信用证到期日期
    ,o.cfm_dt -- 保兑日期
    ,o.advise_dt -- 通知日期
    ,o.issue_bank_name -- 开证行名称
    ,o.benefc_name -- 受益人名称
    ,o.cfm_way_cd -- 保兑方式代码
    ,o.exp_dt -- 出口日期
    ,o.tran_cmplt_site -- 交易完成地点
    ,o.lc_type_cd -- 信用证类型代码
    ,o.pre_advise_dt -- 预通知日期
    ,o.cty_cd -- 国家代码
    ,o.red_green_claus_flg -- 红绿条款标志
    ,o.cfm_pct -- 保兑百分比
    ,o.belong_org_id -- 所属机构编号
    ,o.tran_org_id -- 交易机构编号
    ,o.dom_lc_flg -- 国内信用证标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_exp_lc_h_isbsf1_bk o
    left join ${iml_schema}.agt_exp_lc_h_isbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_exp_lc_h_isbsf1_cl d
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
--truncate table ${iml_schema}.agt_exp_lc_h;
alter table ${iml_schema}.agt_exp_lc_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_exp_lc_h exchange subpartition p_isbsf1_19000101 with table ${iml_schema}.agt_exp_lc_h_isbsf1_cl;
alter table ${iml_schema}.agt_exp_lc_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.agt_exp_lc_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_exp_lc_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_exp_lc_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_exp_lc_h_isbsf1_op purge;
drop table ${iml_schema}.agt_exp_lc_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_exp_lc_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_exp_lc_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
