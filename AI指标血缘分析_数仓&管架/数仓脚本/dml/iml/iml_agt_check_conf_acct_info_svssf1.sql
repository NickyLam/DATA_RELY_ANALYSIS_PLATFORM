/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_check_conf_acct_info_svssf1
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
alter table ${iml_schema}.agt_check_conf_acct_info add partition p_svssf1 values ('svssf1')(
        subpartition p_svssf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_svssf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_check_conf_acct_info_svssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_check_conf_acct_info partition for ('svssf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_check_conf_acct_info_svssf1_tm purge;
drop table ${iml_schema}.agt_check_conf_acct_info_svssf1_op purge;
drop table ${iml_schema}.agt_check_conf_acct_info_svssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_check_conf_acct_info_svssf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_flow_num -- 签约流水号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,open_acct_dt -- 开户日期
    ,acct_start_use_dt -- 账户启用日期
    ,acct_wrtoff_dt -- 账户注销日期
    ,curr_cd -- 币种代码
    ,brac_id -- 网点编号
    ,cotas_name -- 联系人名称
    ,cotas_addr -- 联系人地址
    ,tel_num -- 电话号码
    ,unite_acct_flg -- 联合账户标志
    ,oper_teller_id -- 操作柜员编号
    ,check_teller_id -- 复核柜员编号
    ,acct_status_cd -- 账户状态代码
    ,pt_type_cd -- 支付工具类型代码
    ,acct_type_cd -- 账户类型代码
    ,long_hang_acct_flg -- 久悬户标志
    ,main_acct_sign_flow_num -- 主账户签约流水号
    ,main_acct_acct_id -- 主账户账户编号
    ,cust_id -- 客户编号
    ,general_exch_flg_cd -- 通兑标志代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_check_conf_acct_info partition for ('svssf1')
where 0=1
;

create table ${iml_schema}.agt_check_conf_acct_info_svssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_check_conf_acct_info partition for ('svssf1') where 0=1;

create table ${iml_schema}.agt_check_conf_acct_info_svssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_check_conf_acct_info partition for ('svssf1') where 0=1;

-- 3.1 get new data into table
-- svs_accadm_accinfo-
insert into ${iml_schema}.agt_check_conf_acct_info_svssf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_flow_num -- 签约流水号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,open_acct_dt -- 开户日期
    ,acct_start_use_dt -- 账户启用日期
    ,acct_wrtoff_dt -- 账户注销日期
    ,curr_cd -- 币种代码
    ,brac_id -- 网点编号
    ,cotas_name -- 联系人名称
    ,cotas_addr -- 联系人地址
    ,tel_num -- 电话号码
    ,unite_acct_flg -- 联合账户标志
    ,oper_teller_id -- 操作柜员编号
    ,check_teller_id -- 复核柜员编号
    ,acct_status_cd -- 账户状态代码
    ,pt_type_cd -- 支付工具类型代码
    ,acct_type_cd -- 账户类型代码
    ,long_hang_acct_flg -- 久悬户标志
    ,main_acct_sign_flow_num -- 主账户签约流水号
    ,main_acct_acct_id -- 主账户账户编号
    ,cust_id -- 客户编号
    ,general_exch_flg_cd -- 通兑标志代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '180000'||P1.ACC_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ID -- 签约流水号
    ,P1.ACC_NO -- 账户编号
    ,P1.ACC_NAME -- 账户名称
    ,${iml_schema}.DATEFORMAT_MIN(P1.OPEN_DATE) -- 开户日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.START_DATE) -- 账户启用日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.END_DATE) -- 账户注销日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CURRENCY_TYPE END -- 币种代码
    ,P1.POINT_NO -- 网点编号
    ,P1.LINK_MAN -- 联系人名称
    ,P1.ADDRESS -- 联系人地址
    ,P1.TELEPHONE -- 电话号码
    ,NVL(TRIM(TO_CHAR(P1.IF_COMBINE)),'-') -- 联合账户标志
    ,P1.INPUT_OP -- 操作柜员编号
    ,P1.CHECK_OP -- 复核柜员编号
    ,NVL(TRIM(TO_CHAR(P1.CRUD_FLAG)),'-') -- 账户状态代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||TRIM(TO_CHAR(P1.ACC_TYPE)) END -- 支付工具类型代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||TRIM(TO_CHAR(P1.ACC_CATEGORY)) END -- 账户类型代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||TRIM(TO_CHAR(P1.SLEEP_FLAG)) END -- 久悬户标志
    ,P1.MAIN_ACC_ID -- 主账户签约流水号
    ,P1.MAIN_ACC_NO -- 主账户账户编号
    ,P1.CUST_NO -- 客户编号
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||TRIM(TO_CHAR(P1.WITH_DRAW_FLAG)) END -- 通兑标志代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'svss_svs_accadm_accinfo' -- 源表名称
    ,'svssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.svss_svs_accadm_accinfo p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CURRENCY_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'SVSS'
        AND R1.SRC_TAB_EN_NAME= 'SVSS_SVS_ACCADM_ACCINFO'
        AND R1.SRC_FIELD_EN_NAME= 'CURRENCY_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_CHECK_CONF_ACCT_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on TO_CHAR(P1.ACC_TYPE)= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'SVSS'
        AND R2.SRC_TAB_EN_NAME= 'SVSS_SVS_ACCADM_ACCINFO'
        AND R2.SRC_FIELD_EN_NAME= 'ACC_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_CHECK_CONF_ACCT_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on TO_CHAR(P1.ACC_CATEGORY)= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'SVSS'
        AND R3.SRC_TAB_EN_NAME= 'SVSS_SVS_ACCADM_ACCINFO'
        AND R3.SRC_FIELD_EN_NAME= 'ACC_CATEGORY'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_CHECK_CONF_ACCT_INFO'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'ACCT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on TO_CHAR(P1.SLEEP_FLAG)= R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'SVSS'
        AND R5.SRC_TAB_EN_NAME= 'SVSS_SVS_ACCADM_ACCINFO'
        AND R5.SRC_FIELD_EN_NAME= 'SLEEP_FLAG'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_CHECK_CONF_ACCT_INFO'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'LONG_HANG_ACCT_FLG'
    left join ${iml_schema}.ref_pub_cd_map r4 on TO_CHAR(P1.WITH_DRAW_FLAG)= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'SVSS'
        AND R4.SRC_TAB_EN_NAME= 'SVSS_SVS_ACCADM_ACCINFO'
        AND R4.SRC_FIELD_EN_NAME= 'WITH_DRAW_FLAG'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_CHECK_CONF_ACCT_INFO'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'GENERAL_EXCH_FLG_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_check_conf_acct_info_svssf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,sign_flow_num
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
        into ${iml_schema}.agt_check_conf_acct_info_svssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_flow_num -- 签约流水号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,open_acct_dt -- 开户日期
    ,acct_start_use_dt -- 账户启用日期
    ,acct_wrtoff_dt -- 账户注销日期
    ,curr_cd -- 币种代码
    ,brac_id -- 网点编号
    ,cotas_name -- 联系人名称
    ,cotas_addr -- 联系人地址
    ,tel_num -- 电话号码
    ,unite_acct_flg -- 联合账户标志
    ,oper_teller_id -- 操作柜员编号
    ,check_teller_id -- 复核柜员编号
    ,acct_status_cd -- 账户状态代码
    ,pt_type_cd -- 支付工具类型代码
    ,acct_type_cd -- 账户类型代码
    ,long_hang_acct_flg -- 久悬户标志
    ,main_acct_sign_flow_num -- 主账户签约流水号
    ,main_acct_acct_id -- 主账户账户编号
    ,cust_id -- 客户编号
    ,general_exch_flg_cd -- 通兑标志代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_check_conf_acct_info_svssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_flow_num -- 签约流水号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,open_acct_dt -- 开户日期
    ,acct_start_use_dt -- 账户启用日期
    ,acct_wrtoff_dt -- 账户注销日期
    ,curr_cd -- 币种代码
    ,brac_id -- 网点编号
    ,cotas_name -- 联系人名称
    ,cotas_addr -- 联系人地址
    ,tel_num -- 电话号码
    ,unite_acct_flg -- 联合账户标志
    ,oper_teller_id -- 操作柜员编号
    ,check_teller_id -- 复核柜员编号
    ,acct_status_cd -- 账户状态代码
    ,pt_type_cd -- 支付工具类型代码
    ,acct_type_cd -- 账户类型代码
    ,long_hang_acct_flg -- 久悬户标志
    ,main_acct_sign_flow_num -- 主账户签约流水号
    ,main_acct_acct_id -- 主账户账户编号
    ,cust_id -- 客户编号
    ,general_exch_flg_cd -- 通兑标志代码
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
    ,nvl(n.sign_flow_num, o.sign_flow_num) as sign_flow_num -- 签约流水号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.open_acct_dt, o.open_acct_dt) as open_acct_dt -- 开户日期
    ,nvl(n.acct_start_use_dt, o.acct_start_use_dt) as acct_start_use_dt -- 账户启用日期
    ,nvl(n.acct_wrtoff_dt, o.acct_wrtoff_dt) as acct_wrtoff_dt -- 账户注销日期
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.brac_id, o.brac_id) as brac_id -- 网点编号
    ,nvl(n.cotas_name, o.cotas_name) as cotas_name -- 联系人名称
    ,nvl(n.cotas_addr, o.cotas_addr) as cotas_addr -- 联系人地址
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 电话号码
    ,nvl(n.unite_acct_flg, o.unite_acct_flg) as unite_acct_flg -- 联合账户标志
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 操作柜员编号
    ,nvl(n.check_teller_id, o.check_teller_id) as check_teller_id -- 复核柜员编号
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.pt_type_cd, o.pt_type_cd) as pt_type_cd -- 支付工具类型代码
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.long_hang_acct_flg, o.long_hang_acct_flg) as long_hang_acct_flg -- 久悬户标志
    ,nvl(n.main_acct_sign_flow_num, o.main_acct_sign_flow_num) as main_acct_sign_flow_num -- 主账户签约流水号
    ,nvl(n.main_acct_acct_id, o.main_acct_acct_id) as main_acct_acct_id -- 主账户账户编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.general_exch_flg_cd, o.general_exch_flg_cd) as general_exch_flg_cd -- 通兑标志代码
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.sign_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.sign_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.sign_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_check_conf_acct_info_svssf1_tm n
    full join (select * from ${iml_schema}.agt_check_conf_acct_info_svssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.sign_flow_num = n.sign_flow_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.sign_flow_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.sign_flow_num is null
    )
    or (
        o.acct_id <> n.acct_id
        or o.acct_name <> n.acct_name
        or o.open_acct_dt <> n.open_acct_dt
        or o.acct_start_use_dt <> n.acct_start_use_dt
        or o.acct_wrtoff_dt <> n.acct_wrtoff_dt
        or o.curr_cd <> n.curr_cd
        or o.brac_id <> n.brac_id
        or o.cotas_name <> n.cotas_name
        or o.cotas_addr <> n.cotas_addr
        or o.tel_num <> n.tel_num
        or o.unite_acct_flg <> n.unite_acct_flg
        or o.oper_teller_id <> n.oper_teller_id
        or o.check_teller_id <> n.check_teller_id
        or o.acct_status_cd <> n.acct_status_cd
        or o.pt_type_cd <> n.pt_type_cd
        or o.acct_type_cd <> n.acct_type_cd
        or o.long_hang_acct_flg <> n.long_hang_acct_flg
        or o.main_acct_sign_flow_num <> n.main_acct_sign_flow_num
        or o.main_acct_acct_id <> n.main_acct_acct_id
        or o.cust_id <> n.cust_id
        or o.general_exch_flg_cd <> n.general_exch_flg_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_check_conf_acct_info_svssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_flow_num -- 签约流水号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,open_acct_dt -- 开户日期
    ,acct_start_use_dt -- 账户启用日期
    ,acct_wrtoff_dt -- 账户注销日期
    ,curr_cd -- 币种代码
    ,brac_id -- 网点编号
    ,cotas_name -- 联系人名称
    ,cotas_addr -- 联系人地址
    ,tel_num -- 电话号码
    ,unite_acct_flg -- 联合账户标志
    ,oper_teller_id -- 操作柜员编号
    ,check_teller_id -- 复核柜员编号
    ,acct_status_cd -- 账户状态代码
    ,pt_type_cd -- 支付工具类型代码
    ,acct_type_cd -- 账户类型代码
    ,long_hang_acct_flg -- 久悬户标志
    ,main_acct_sign_flow_num -- 主账户签约流水号
    ,main_acct_acct_id -- 主账户账户编号
    ,cust_id -- 客户编号
    ,general_exch_flg_cd -- 通兑标志代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_check_conf_acct_info_svssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_flow_num -- 签约流水号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,open_acct_dt -- 开户日期
    ,acct_start_use_dt -- 账户启用日期
    ,acct_wrtoff_dt -- 账户注销日期
    ,curr_cd -- 币种代码
    ,brac_id -- 网点编号
    ,cotas_name -- 联系人名称
    ,cotas_addr -- 联系人地址
    ,tel_num -- 电话号码
    ,unite_acct_flg -- 联合账户标志
    ,oper_teller_id -- 操作柜员编号
    ,check_teller_id -- 复核柜员编号
    ,acct_status_cd -- 账户状态代码
    ,pt_type_cd -- 支付工具类型代码
    ,acct_type_cd -- 账户类型代码
    ,long_hang_acct_flg -- 久悬户标志
    ,main_acct_sign_flow_num -- 主账户签约流水号
    ,main_acct_acct_id -- 主账户账户编号
    ,cust_id -- 客户编号
    ,general_exch_flg_cd -- 通兑标志代码
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
    ,o.sign_flow_num -- 签约流水号
    ,o.acct_id -- 账户编号
    ,o.acct_name -- 账户名称
    ,o.open_acct_dt -- 开户日期
    ,o.acct_start_use_dt -- 账户启用日期
    ,o.acct_wrtoff_dt -- 账户注销日期
    ,o.curr_cd -- 币种代码
    ,o.brac_id -- 网点编号
    ,o.cotas_name -- 联系人名称
    ,o.cotas_addr -- 联系人地址
    ,o.tel_num -- 电话号码
    ,o.unite_acct_flg -- 联合账户标志
    ,o.oper_teller_id -- 操作柜员编号
    ,o.check_teller_id -- 复核柜员编号
    ,o.acct_status_cd -- 账户状态代码
    ,o.pt_type_cd -- 支付工具类型代码
    ,o.acct_type_cd -- 账户类型代码
    ,o.long_hang_acct_flg -- 久悬户标志
    ,o.main_acct_sign_flow_num -- 主账户签约流水号
    ,o.main_acct_acct_id -- 主账户账户编号
    ,o.cust_id -- 客户编号
    ,o.general_exch_flg_cd -- 通兑标志代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_check_conf_acct_info_svssf1_bk o
    left join ${iml_schema}.agt_check_conf_acct_info_svssf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.sign_flow_num = n.sign_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_check_conf_acct_info_svssf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.sign_flow_num = d.sign_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_check_conf_acct_info;
alter table ${iml_schema}.agt_check_conf_acct_info truncate partition for ('svssf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_check_conf_acct_info exchange subpartition p_svssf1_19000101 with table ${iml_schema}.agt_check_conf_acct_info_svssf1_cl;
alter table ${iml_schema}.agt_check_conf_acct_info exchange subpartition p_svssf1_20991231 with table ${iml_schema}.agt_check_conf_acct_info_svssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_check_conf_acct_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_check_conf_acct_info_svssf1_tm purge;
drop table ${iml_schema}.agt_check_conf_acct_info_svssf1_op purge;
drop table ${iml_schema}.agt_check_conf_acct_info_svssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_check_conf_acct_info_svssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_check_conf_acct_info', partname => 'p_svssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
