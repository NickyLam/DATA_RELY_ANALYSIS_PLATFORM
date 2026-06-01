/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_unionpay_sign_info_h_pppsf1
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
alter table ${iml_schema}.agt_unionpay_sign_info_h add partition p_pppsf1 values ('pppsf1')(
        subpartition p_pppsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_pppsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_unionpay_sign_info_h partition for ('pppsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_tm purge;
drop table ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_op purge;
drop table ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_agt_id -- 签约协议编号
    ,sign_dt -- 签约日期
    ,sign_status_cd -- 签约状态代码
    ,sign_acct_unionpay_org_id -- 签约账户银联机构编号
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_level_cd -- 签约账户等级代码
    ,sign_type_cd -- 签约类型代码
    ,cust_id -- 客户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,agt_invalid_dt -- 协议失效日期
    ,init_bus_kind_id -- 原业务种类编号
    ,init_acct_id -- 发起账户编号
    ,intior_belong_org_id -- 发起方所属机构编号
    ,init_acct_unionpay_org_id -- 发起账户银联机构编号
    ,intior_unionpay_org_id -- 发起方银联机构编号
    ,init_org_name -- 发起机构名称
    ,open_acct_org_id -- 开户机构编号
    ,ova_flow_num -- 全局流水号
    ,vtual_teller_id -- 虚拟柜员编号
    ,bus_flow_num -- 业务流水号
    ,tran_flow_num -- 交易流水号
    ,create_date -- 创建日期
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_unionpay_sign_info_h partition for ('pppsf1')
where 0=1
;

create table ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_unionpay_sign_info_h partition for ('pppsf1') where 0=1;

create table ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_unionpay_sign_info_h partition for ('pppsf1') where 0=1;

-- 3.1 get new data into table
-- ppps_u_contract-1
insert into ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_agt_id -- 签约协议编号
    ,sign_dt -- 签约日期
    ,sign_status_cd -- 签约状态代码
    ,sign_acct_unionpay_org_id -- 签约账户银联机构编号
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_level_cd -- 签约账户等级代码
    ,sign_type_cd -- 签约类型代码
    ,cust_id -- 客户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,agt_invalid_dt -- 协议失效日期
    ,init_bus_kind_id -- 原业务种类编号
    ,init_acct_id -- 发起账户编号
    ,intior_belong_org_id -- 发起方所属机构编号
    ,init_acct_unionpay_org_id -- 发起账户银联机构编号
    ,intior_unionpay_org_id -- 发起方银联机构编号
    ,init_org_name -- 发起机构名称
    ,open_acct_org_id -- 开户机构编号
    ,ova_flow_num -- 全局流水号
    ,vtual_teller_id -- 虚拟柜员编号
    ,bus_flow_num -- 业务流水号
    ,tran_flow_num -- 交易流水号
    ,create_date -- 创建日期
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300048'||P1.SGN_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SGN_NO -- 签约协议编号
    ,${iml_schema}.dateformat_max2(P1.SGN_DATE||P1.SGN_TIME) -- 签约日期
    ,nvl(trim(P1.SGN_STATUS),'-') -- 签约状态代码
    ,P1.RCVER_ACCT_ISSR_ID -- 签约账户银联机构编号
    ,nvl(trim(P1.SGN_ACCT_TP),'-') -- 签约账户类型代码
    ,P1.RCVER_ACCT_ID -- 签约账户编号
    ,P1.RCVER_NM -- 签约账户名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.ACCT_LVL END -- 签约账户等级代码
    ,nvl(trim(P1.SGN_TYP),'-') -- 签约类型代码
    ,P1.PTY_ID -- 客户编号
    ,nvl(trim(P1.ID_TP),'0000') -- 证件类型代码
    ,P1.ID_NO -- 证件号码
    ,P1.MOB_NO -- 手机号码
    ,${iml_schema}.dateformat_max2(P1.EXPIRE_DATE) -- 协议失效日期
    ,P1.BIZ_TP -- 原业务种类编号
    ,P1.SDER_ACCT_ID -- 发起账户编号
    ,P1.ISSR_ID -- 发起方所属机构编号
    ,P1.SDER_ACCT_ISSR_ID -- 发起账户银联机构编号
    ,P1.SDER_ISSR_ID -- 发起方银联机构编号
    ,P1.SDER_ACCT_ISSR_NM -- 发起机构名称
    ,P1.OPEN_ORG_ID -- 开户机构编号
    ,P1.GLOBAL_SEQ_NO -- 全局流水号
    ,P1.TRAN_TELLER_NO -- 虚拟柜员编号
    ,P1.TRAN_SEQ_NO -- 业务流水号
    ,P1.TRX_ID -- 交易流水号
    ,${iml_schema}.dateformat_min(P1.INSERT_TIME) -- 创建日期
    ,${iml_schema}.dateformat_max2(P1.UPDATE_TIME) -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ppps_u_contract' -- 源表名称
    ,'pppsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ppps_u_contract p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ACCT_LVL= R1.SRC_CODE_VAL
        AND R1.SRC_TAB_EN_NAME= 'PPPS_U_CONTRACT'
        AND R1.SRC_FIELD_EN_NAME= 'ACCT_LVL'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_UNIONPAY_SIGN_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'SIGN_ACCT_LEVEL_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_tm 
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
        into ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_agt_id -- 签约协议编号
    ,sign_dt -- 签约日期
    ,sign_status_cd -- 签约状态代码
    ,sign_acct_unionpay_org_id -- 签约账户银联机构编号
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_level_cd -- 签约账户等级代码
    ,sign_type_cd -- 签约类型代码
    ,cust_id -- 客户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,agt_invalid_dt -- 协议失效日期
    ,init_bus_kind_id -- 原业务种类编号
    ,init_acct_id -- 发起账户编号
    ,intior_belong_org_id -- 发起方所属机构编号
    ,init_acct_unionpay_org_id -- 发起账户银联机构编号
    ,intior_unionpay_org_id -- 发起方银联机构编号
    ,init_org_name -- 发起机构名称
    ,open_acct_org_id -- 开户机构编号
    ,ova_flow_num -- 全局流水号
    ,vtual_teller_id -- 虚拟柜员编号
    ,bus_flow_num -- 业务流水号
    ,tran_flow_num -- 交易流水号
    ,create_date -- 创建日期
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_agt_id -- 签约协议编号
    ,sign_dt -- 签约日期
    ,sign_status_cd -- 签约状态代码
    ,sign_acct_unionpay_org_id -- 签约账户银联机构编号
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_level_cd -- 签约账户等级代码
    ,sign_type_cd -- 签约类型代码
    ,cust_id -- 客户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,agt_invalid_dt -- 协议失效日期
    ,init_bus_kind_id -- 原业务种类编号
    ,init_acct_id -- 发起账户编号
    ,intior_belong_org_id -- 发起方所属机构编号
    ,init_acct_unionpay_org_id -- 发起账户银联机构编号
    ,intior_unionpay_org_id -- 发起方银联机构编号
    ,init_org_name -- 发起机构名称
    ,open_acct_org_id -- 开户机构编号
    ,ova_flow_num -- 全局流水号
    ,vtual_teller_id -- 虚拟柜员编号
    ,bus_flow_num -- 业务流水号
    ,tran_flow_num -- 交易流水号
    ,create_date -- 创建日期
    ,final_update_dt -- 最后更新日期
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
    ,nvl(n.sign_agt_id, o.sign_agt_id) as sign_agt_id -- 签约协议编号
    ,nvl(n.sign_dt, o.sign_dt) as sign_dt -- 签约日期
    ,nvl(n.sign_status_cd, o.sign_status_cd) as sign_status_cd -- 签约状态代码
    ,nvl(n.sign_acct_unionpay_org_id, o.sign_acct_unionpay_org_id) as sign_acct_unionpay_org_id -- 签约账户银联机构编号
    ,nvl(n.sign_acct_type_cd, o.sign_acct_type_cd) as sign_acct_type_cd -- 签约账户类型代码
    ,nvl(n.sign_acct_id, o.sign_acct_id) as sign_acct_id -- 签约账户编号
    ,nvl(n.sign_acct_name, o.sign_acct_name) as sign_acct_name -- 签约账户名称
    ,nvl(n.sign_acct_level_cd, o.sign_acct_level_cd) as sign_acct_level_cd -- 签约账户等级代码
    ,nvl(n.sign_type_cd, o.sign_type_cd) as sign_type_cd -- 签约类型代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.agt_invalid_dt, o.agt_invalid_dt) as agt_invalid_dt -- 协议失效日期
    ,nvl(n.init_bus_kind_id, o.init_bus_kind_id) as init_bus_kind_id -- 原业务种类编号
    ,nvl(n.init_acct_id, o.init_acct_id) as init_acct_id -- 发起账户编号
    ,nvl(n.intior_belong_org_id, o.intior_belong_org_id) as intior_belong_org_id -- 发起方所属机构编号
    ,nvl(n.init_acct_unionpay_org_id, o.init_acct_unionpay_org_id) as init_acct_unionpay_org_id -- 发起账户银联机构编号
    ,nvl(n.intior_unionpay_org_id, o.intior_unionpay_org_id) as intior_unionpay_org_id -- 发起方银联机构编号
    ,nvl(n.init_org_name, o.init_org_name) as init_org_name -- 发起机构名称
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.ova_flow_num, o.ova_flow_num) as ova_flow_num -- 全局流水号
    ,nvl(n.vtual_teller_id, o.vtual_teller_id) as vtual_teller_id -- 虚拟柜员编号
    ,nvl(n.bus_flow_num, o.bus_flow_num) as bus_flow_num -- 业务流水号
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.create_date, o.create_date) as create_date -- 创建日期
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
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
from ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_tm n
    full join (select * from ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.sign_agt_id <> n.sign_agt_id
        or o.sign_dt <> n.sign_dt
        or o.sign_status_cd <> n.sign_status_cd
        or o.sign_acct_unionpay_org_id <> n.sign_acct_unionpay_org_id
        or o.sign_acct_type_cd <> n.sign_acct_type_cd
        or o.sign_acct_id <> n.sign_acct_id
        or o.sign_acct_name <> n.sign_acct_name
        or o.sign_acct_level_cd <> n.sign_acct_level_cd
        or o.sign_type_cd <> n.sign_type_cd
        or o.cust_id <> n.cust_id
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.mobile_no <> n.mobile_no
        or o.agt_invalid_dt <> n.agt_invalid_dt
        or o.init_bus_kind_id <> n.init_bus_kind_id
        or o.init_acct_id <> n.init_acct_id
        or o.intior_belong_org_id <> n.intior_belong_org_id
        or o.init_acct_unionpay_org_id <> n.init_acct_unionpay_org_id
        or o.intior_unionpay_org_id <> n.intior_unionpay_org_id
        or o.init_org_name <> n.init_org_name
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.ova_flow_num <> n.ova_flow_num
        or o.vtual_teller_id <> n.vtual_teller_id
        or o.bus_flow_num <> n.bus_flow_num
        or o.tran_flow_num <> n.tran_flow_num
        or o.create_date <> n.create_date
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_agt_id -- 签约协议编号
    ,sign_dt -- 签约日期
    ,sign_status_cd -- 签约状态代码
    ,sign_acct_unionpay_org_id -- 签约账户银联机构编号
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_level_cd -- 签约账户等级代码
    ,sign_type_cd -- 签约类型代码
    ,cust_id -- 客户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,agt_invalid_dt -- 协议失效日期
    ,init_bus_kind_id -- 原业务种类编号
    ,init_acct_id -- 发起账户编号
    ,intior_belong_org_id -- 发起方所属机构编号
    ,init_acct_unionpay_org_id -- 发起账户银联机构编号
    ,intior_unionpay_org_id -- 发起方银联机构编号
    ,init_org_name -- 发起机构名称
    ,open_acct_org_id -- 开户机构编号
    ,ova_flow_num -- 全局流水号
    ,vtual_teller_id -- 虚拟柜员编号
    ,bus_flow_num -- 业务流水号
    ,tran_flow_num -- 交易流水号
    ,create_date -- 创建日期
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_agt_id -- 签约协议编号
    ,sign_dt -- 签约日期
    ,sign_status_cd -- 签约状态代码
    ,sign_acct_unionpay_org_id -- 签约账户银联机构编号
    ,sign_acct_type_cd -- 签约账户类型代码
    ,sign_acct_id -- 签约账户编号
    ,sign_acct_name -- 签约账户名称
    ,sign_acct_level_cd -- 签约账户等级代码
    ,sign_type_cd -- 签约类型代码
    ,cust_id -- 客户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,agt_invalid_dt -- 协议失效日期
    ,init_bus_kind_id -- 原业务种类编号
    ,init_acct_id -- 发起账户编号
    ,intior_belong_org_id -- 发起方所属机构编号
    ,init_acct_unionpay_org_id -- 发起账户银联机构编号
    ,intior_unionpay_org_id -- 发起方银联机构编号
    ,init_org_name -- 发起机构名称
    ,open_acct_org_id -- 开户机构编号
    ,ova_flow_num -- 全局流水号
    ,vtual_teller_id -- 虚拟柜员编号
    ,bus_flow_num -- 业务流水号
    ,tran_flow_num -- 交易流水号
    ,create_date -- 创建日期
    ,final_update_dt -- 最后更新日期
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
    ,o.sign_agt_id -- 签约协议编号
    ,o.sign_dt -- 签约日期
    ,o.sign_status_cd -- 签约状态代码
    ,o.sign_acct_unionpay_org_id -- 签约账户银联机构编号
    ,o.sign_acct_type_cd -- 签约账户类型代码
    ,o.sign_acct_id -- 签约账户编号
    ,o.sign_acct_name -- 签约账户名称
    ,o.sign_acct_level_cd -- 签约账户等级代码
    ,o.sign_type_cd -- 签约类型代码
    ,o.cust_id -- 客户编号
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.mobile_no -- 手机号码
    ,o.agt_invalid_dt -- 协议失效日期
    ,o.init_bus_kind_id -- 原业务种类编号
    ,o.init_acct_id -- 发起账户编号
    ,o.intior_belong_org_id -- 发起方所属机构编号
    ,o.init_acct_unionpay_org_id -- 发起账户银联机构编号
    ,o.intior_unionpay_org_id -- 发起方银联机构编号
    ,o.init_org_name -- 发起机构名称
    ,o.open_acct_org_id -- 开户机构编号
    ,o.ova_flow_num -- 全局流水号
    ,o.vtual_teller_id -- 虚拟柜员编号
    ,o.bus_flow_num -- 业务流水号
    ,o.tran_flow_num -- 交易流水号
    ,o.create_date -- 创建日期
    ,o.final_update_dt -- 最后更新日期
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
from ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_bk o
    left join ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_cl d
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
--truncate table ${iml_schema}.agt_unionpay_sign_info_h;
--alter table ${iml_schema}.agt_unionpay_sign_info_h truncate partition for ('pppsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_unionpay_sign_info_h') 
               and substr(subpartition_name,1,8)=upper('p_pppsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_unionpay_sign_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_unionpay_sign_info_h modify partition p_pppsf1 
add subpartition p_pppsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_unionpay_sign_info_h exchange subpartition p_pppsf1_${batch_date} with table ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_cl;
alter table ${iml_schema}.agt_unionpay_sign_info_h exchange subpartition p_pppsf1_20991231 with table ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_unionpay_sign_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_tm purge;
drop table ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_op purge;
drop table ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_unionpay_sign_info_h_pppsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_unionpay_sign_info_h', partname => 'p_pppsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
