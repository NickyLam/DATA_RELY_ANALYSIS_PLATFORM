/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_user_move_equip_para_h_mpcsf1
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
alter table ${iml_schema}.ref_user_move_equip_para_h add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_user_move_equip_para_h partition for ('mpcsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_tm purge;
drop table ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_op purge;
drop table ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    main_acct_id -- 主账户编号
    ,lp_id -- 法人编号
    ,main_acct_idf_id -- 主账户标识编号
    ,move_termn_type_cd -- 移动终端类型代码
    ,save_chip_idf_id -- 安全芯片标识编号
    ,equip_card_no -- 设备卡号
    ,equip_card_idf_id -- 设备卡标识编号
    ,equip_card_status_cd -- 设备卡状态代码
    ,oper_tm -- 操作时间
    ,cust_id -- 客户编号
    ,card_holder_name -- 持卡人姓名
    ,rsrv_mobile_no -- 预留手机号码
    ,init_chn_cd -- 发起渠道代码
    ,agt_claus_id -- 协议条款编号
    ,claus_acpt_dt -- 条款接受日期
    ,vp -- 有效期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_user_move_equip_para_h partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_user_move_equip_para_h partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_user_move_equip_para_h partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a86mpanmapinfo-
insert into ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_tm(
    main_acct_id -- 主账户编号
    ,lp_id -- 法人编号
    ,main_acct_idf_id -- 主账户标识编号
    ,move_termn_type_cd -- 移动终端类型代码
    ,save_chip_idf_id -- 安全芯片标识编号
    ,equip_card_no -- 设备卡号
    ,equip_card_idf_id -- 设备卡标识编号
    ,equip_card_status_cd -- 设备卡状态代码
    ,oper_tm -- 操作时间
    ,cust_id -- 客户编号
    ,card_holder_name -- 持卡人姓名
    ,rsrv_mobile_no -- 预留手机号码
    ,init_chn_cd -- 发起渠道代码
    ,agt_claus_id -- 协议条款编号
    ,claus_acpt_dt -- 条款接受日期
    ,vp -- 有效期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SPAN -- 主账户编号
    ,'9999' -- 法人编号
    ,P1.SPANID -- 主账户标识编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PAYSYS END -- 移动终端类型代码
    ,P1.SEID -- 安全芯片标识编号
    ,P1.MPAN -- 设备卡号
    ,P1.MPANID -- 设备卡标识编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.MAPPINGSTATUS END -- 设备卡状态代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRANSTIME) -- 操作时间
    ,P1.CUSTNO -- 客户编号
    ,P1.CUSTNAME -- 持卡人姓名
    ,P1.PHONE -- 预留手机号码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.OPECHANNELID END -- 发起渠道代码
    ,P1.TERMCONDITIONID -- 协议条款编号
    ,${iml_schema}.DATEFORMAT_MAX(substr(P1.TERMCONDITIONACCEPTEDDATE,1,10)) -- 条款接受日期
    ,P1.INVALUEDATE -- 有效期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a86mpanmapinfo' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a86mpanmapinfo p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PAYSYS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A86MPANMAPINFO'
        AND R1.SRC_FIELD_EN_NAME= 'PAYSYS'
        AND R1.TARGET_TAB_EN_NAME= 'REF_USER_MOVE_EQUIP_PARA_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'MOVE_TERMN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.MAPPINGSTATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A86MPANMAPINFO'
        AND R2.SRC_FIELD_EN_NAME= 'MAPPINGSTATUS'
        AND R2.TARGET_TAB_EN_NAME= 'REF_USER_MOVE_EQUIP_PARA_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'EQUIP_CARD_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.OPECHANNELID = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A86MPANMAPINFO'
        AND R3.SRC_FIELD_EN_NAME= 'OPECHANNELID'
        AND R3.TARGET_TAB_EN_NAME= 'REF_USER_MOVE_EQUIP_PARA_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'INIT_CHN_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_cl(
            main_acct_id -- 主账户编号
    ,lp_id -- 法人编号
    ,main_acct_idf_id -- 主账户标识编号
    ,move_termn_type_cd -- 移动终端类型代码
    ,save_chip_idf_id -- 安全芯片标识编号
    ,equip_card_no -- 设备卡号
    ,equip_card_idf_id -- 设备卡标识编号
    ,equip_card_status_cd -- 设备卡状态代码
    ,oper_tm -- 操作时间
    ,cust_id -- 客户编号
    ,card_holder_name -- 持卡人姓名
    ,rsrv_mobile_no -- 预留手机号码
    ,init_chn_cd -- 发起渠道代码
    ,agt_claus_id -- 协议条款编号
    ,claus_acpt_dt -- 条款接受日期
    ,vp -- 有效期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_op(
            main_acct_id -- 主账户编号
    ,lp_id -- 法人编号
    ,main_acct_idf_id -- 主账户标识编号
    ,move_termn_type_cd -- 移动终端类型代码
    ,save_chip_idf_id -- 安全芯片标识编号
    ,equip_card_no -- 设备卡号
    ,equip_card_idf_id -- 设备卡标识编号
    ,equip_card_status_cd -- 设备卡状态代码
    ,oper_tm -- 操作时间
    ,cust_id -- 客户编号
    ,card_holder_name -- 持卡人姓名
    ,rsrv_mobile_no -- 预留手机号码
    ,init_chn_cd -- 发起渠道代码
    ,agt_claus_id -- 协议条款编号
    ,claus_acpt_dt -- 条款接受日期
    ,vp -- 有效期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.main_acct_id, o.main_acct_id) as main_acct_id -- 主账户编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.main_acct_idf_id, o.main_acct_idf_id) as main_acct_idf_id -- 主账户标识编号
    ,nvl(n.move_termn_type_cd, o.move_termn_type_cd) as move_termn_type_cd -- 移动终端类型代码
    ,nvl(n.save_chip_idf_id, o.save_chip_idf_id) as save_chip_idf_id -- 安全芯片标识编号
    ,nvl(n.equip_card_no, o.equip_card_no) as equip_card_no -- 设备卡号
    ,nvl(n.equip_card_idf_id, o.equip_card_idf_id) as equip_card_idf_id -- 设备卡标识编号
    ,nvl(n.equip_card_status_cd, o.equip_card_status_cd) as equip_card_status_cd -- 设备卡状态代码
    ,nvl(n.oper_tm, o.oper_tm) as oper_tm -- 操作时间
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.card_holder_name, o.card_holder_name) as card_holder_name -- 持卡人姓名
    ,nvl(n.rsrv_mobile_no, o.rsrv_mobile_no) as rsrv_mobile_no -- 预留手机号码
    ,nvl(n.init_chn_cd, o.init_chn_cd) as init_chn_cd -- 发起渠道代码
    ,nvl(n.agt_claus_id, o.agt_claus_id) as agt_claus_id -- 协议条款编号
    ,nvl(n.claus_acpt_dt, o.claus_acpt_dt) as claus_acpt_dt -- 条款接受日期
    ,nvl(n.vp, o.vp) as vp -- 有效期
    ,case when
            n.main_acct_id is null
            and n.lp_id is null
            and n.main_acct_idf_id is null
            and n.move_termn_type_cd is null
            and n.save_chip_idf_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.main_acct_id is null
            and n.lp_id is null
            and n.main_acct_idf_id is null
            and n.move_termn_type_cd is null
            and n.save_chip_idf_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.main_acct_id is null
            and n.lp_id is null
            and n.main_acct_idf_id is null
            and n.move_termn_type_cd is null
            and n.save_chip_idf_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_tm n
    full join (select * from ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.main_acct_id = n.main_acct_id
            and o.lp_id = n.lp_id
            and o.main_acct_idf_id = n.main_acct_idf_id
            and o.move_termn_type_cd = n.move_termn_type_cd
            and o.save_chip_idf_id = n.save_chip_idf_id
where (
        o.main_acct_id is null
        and o.lp_id is null
        and o.main_acct_idf_id is null
        and o.move_termn_type_cd is null
        and o.save_chip_idf_id is null
    )
    or (
        n.main_acct_id is null
        and n.lp_id is null
        and n.main_acct_idf_id is null
        and n.move_termn_type_cd is null
        and n.save_chip_idf_id is null
    )
    or (
        o.equip_card_no <> n.equip_card_no
        or o.equip_card_idf_id <> n.equip_card_idf_id
        or o.equip_card_status_cd <> n.equip_card_status_cd
        or o.oper_tm <> n.oper_tm
        or o.cust_id <> n.cust_id
        or o.card_holder_name <> n.card_holder_name
        or o.rsrv_mobile_no <> n.rsrv_mobile_no
        or o.init_chn_cd <> n.init_chn_cd
        or o.agt_claus_id <> n.agt_claus_id
        or o.claus_acpt_dt <> n.claus_acpt_dt
        or o.vp <> n.vp
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_cl(
            main_acct_id -- 主账户编号
    ,lp_id -- 法人编号
    ,main_acct_idf_id -- 主账户标识编号
    ,move_termn_type_cd -- 移动终端类型代码
    ,save_chip_idf_id -- 安全芯片标识编号
    ,equip_card_no -- 设备卡号
    ,equip_card_idf_id -- 设备卡标识编号
    ,equip_card_status_cd -- 设备卡状态代码
    ,oper_tm -- 操作时间
    ,cust_id -- 客户编号
    ,card_holder_name -- 持卡人姓名
    ,rsrv_mobile_no -- 预留手机号码
    ,init_chn_cd -- 发起渠道代码
    ,agt_claus_id -- 协议条款编号
    ,claus_acpt_dt -- 条款接受日期
    ,vp -- 有效期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_op(
            main_acct_id -- 主账户编号
    ,lp_id -- 法人编号
    ,main_acct_idf_id -- 主账户标识编号
    ,move_termn_type_cd -- 移动终端类型代码
    ,save_chip_idf_id -- 安全芯片标识编号
    ,equip_card_no -- 设备卡号
    ,equip_card_idf_id -- 设备卡标识编号
    ,equip_card_status_cd -- 设备卡状态代码
    ,oper_tm -- 操作时间
    ,cust_id -- 客户编号
    ,card_holder_name -- 持卡人姓名
    ,rsrv_mobile_no -- 预留手机号码
    ,init_chn_cd -- 发起渠道代码
    ,agt_claus_id -- 协议条款编号
    ,claus_acpt_dt -- 条款接受日期
    ,vp -- 有效期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.main_acct_id -- 主账户编号
    ,o.lp_id -- 法人编号
    ,o.main_acct_idf_id -- 主账户标识编号
    ,o.move_termn_type_cd -- 移动终端类型代码
    ,o.save_chip_idf_id -- 安全芯片标识编号
    ,o.equip_card_no -- 设备卡号
    ,o.equip_card_idf_id -- 设备卡标识编号
    ,o.equip_card_status_cd -- 设备卡状态代码
    ,o.oper_tm -- 操作时间
    ,o.cust_id -- 客户编号
    ,o.card_holder_name -- 持卡人姓名
    ,o.rsrv_mobile_no -- 预留手机号码
    ,o.init_chn_cd -- 发起渠道代码
    ,o.agt_claus_id -- 协议条款编号
    ,o.claus_acpt_dt -- 条款接受日期
    ,o.vp -- 有效期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_bk o
    left join ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_op n
        on
            o.main_acct_id = n.main_acct_id
            and o.lp_id = n.lp_id
            and o.main_acct_idf_id = n.main_acct_idf_id
            and o.move_termn_type_cd = n.move_termn_type_cd
            and o.save_chip_idf_id = n.save_chip_idf_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_cl d
        on
            o.main_acct_id = d.main_acct_id
            and o.lp_id = d.lp_id
            and o.main_acct_idf_id = d.main_acct_idf_id
            and o.move_termn_type_cd = d.move_termn_type_cd
            and o.save_chip_idf_id = d.save_chip_idf_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_user_move_equip_para_h;
alter table ${iml_schema}.ref_user_move_equip_para_h truncate partition for ('mpcsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_user_move_equip_para_h exchange subpartition p_mpcsf1_19000101 with table ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_cl;
alter table ${iml_schema}.ref_user_move_equip_para_h exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_user_move_equip_para_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_tm purge;
drop table ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_op purge;
drop table ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_user_move_equip_para_h_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_user_move_equip_para_h', partname => 'p_mpcsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
