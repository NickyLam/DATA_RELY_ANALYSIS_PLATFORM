/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_insure_pl_inssf1
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
alter table ${iml_schema}.agt_insure_pl add partition p_inssf1 values ('inssf1')(
        subpartition p_inssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_inssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_insure_pl_inssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_insure_pl partition for ('inssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_insure_pl_inssf1_tm purge;
drop table ${iml_schema}.agt_insure_pl_inssf1_op purge;
drop table ${iml_schema}.agt_insure_pl_inssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_insure_pl_inssf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,insure_pl_id -- 保险单编号
    ,ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,bank_id -- 银行编号
    ,cust_mgr_id -- 客户经理编号
    ,cust_id -- 客户编号
    ,insure_print_id -- 保险打印单编号
    ,org_id -- 机构编号
    ,teller_id -- 柜员编号
    ,tran_dt -- 交易日期
    ,seq_num -- 序号
    ,policy_dt -- 保单日期
    ,cfm_dt -- 确认日期
    ,policy_effect_dt -- 保单生效日期
    ,pay_ped -- 支付周期
    ,insure_ped_type_cd -- 保险周期类型代码
    ,insure_ped -- 保险周期
    ,mode_pay_cd -- 支付方式代码
    ,pay_ped_type_cd -- 支付周期类型代码
    ,tran_amt -- 交易金额
    ,insure_fee -- 保险费用
    ,lot -- 份额
    ,bank_acct_id -- 银行账户编号
    ,tran_status_cd -- 交易状态代码
    ,holder_name -- 持有人姓名
    ,holder_cert_type_cd -- 持有人证件类型代码
    ,holder_cert_no -- 持有人证件号码
    ,rela_type_cd -- 关系类型代码
    ,insrt_name -- 被保险人姓名
    ,insrt_cert_type_cd -- 被保险人证件类型代码
    ,insrt_cert_no -- 被保险人证件号码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_insure_pl partition for ('inssf1')
where 0=1
;

create table ${iml_schema}.agt_insure_pl_inssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_insure_pl partition for ('inssf1') where 0=1;

create table ${iml_schema}.agt_insure_pl_inssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_insure_pl partition for ('inssf1') where 0=1;

-- 3.1 get new data into table
-- ifms_tbshareinsure-
insert into ${iml_schema}.agt_insure_pl_inssf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,insure_pl_id -- 保险单编号
    ,ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,bank_id -- 银行编号
    ,cust_mgr_id -- 客户经理编号
    ,cust_id -- 客户编号
    ,insure_print_id -- 保险打印单编号
    ,org_id -- 机构编号
    ,teller_id -- 柜员编号
    ,tran_dt -- 交易日期
    ,seq_num -- 序号
    ,policy_dt -- 保单日期
    ,cfm_dt -- 确认日期
    ,policy_effect_dt -- 保单生效日期
    ,pay_ped -- 支付周期
    ,insure_ped_type_cd -- 保险周期类型代码
    ,insure_ped -- 保险周期
    ,mode_pay_cd -- 支付方式代码
    ,pay_ped_type_cd -- 支付周期类型代码
    ,tran_amt -- 交易金额
    ,insure_fee -- 保险费用
    ,lot -- 份额
    ,bank_acct_id -- 银行账户编号
    ,tran_status_cd -- 交易状态代码
    ,holder_name -- 持有人姓名
    ,holder_cert_type_cd -- 持有人证件类型代码
    ,holder_cert_no -- 持有人证件号码
    ,rela_type_cd -- 关系类型代码
    ,insrt_name -- 被保险人姓名
    ,insrt_cert_type_cd -- 被保险人证件类型代码
    ,insrt_cert_no -- 被保险人证件号码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '160100'||P1.INSURE_NO||P1.TA_CODE||P1.PRD_CODE -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INSURE_NO -- 保险单编号
    ,P1.TA_CODE -- TA代码
    ,P2.PRD_CODE -- 产品编号
    ,case
       when substr(p2.control_flag, 9, 1) = '1' then
        '602020300001'
       when substr(p2.control_flag, 9, 1) = '2' then
        '602020300004'
       when substr(p2.control_flag, 9, 1) = '3' then
        '602020300003'
       when substr(p2.control_flag, 9, 1) = '4' then
        '602020300002'
       when p2.prd_sub_type in ('1', '2', '3') then
        '602020300005'
       else
        '-'
     end -- 标准产品编号
    ,P1.BANK_NO -- 银行编号
    ,P1.CLIENT_MANAGER -- 客户经理编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.INSURE_PRINT -- 保险打印单编号
    ,P1.BRANCH_NO -- 机构编号
    ,P1.OPER_NO -- 柜员编号
    ,${iml_schema}.dateformat_max(to_char(P1.TRANS_DATE)) -- 交易日期
    ,P1.SERIAL_NO -- 序号
    ,${iml_schema}.dateformat_max(to_char(P1.INSURE_DATE)) -- 保单日期
    ,${iml_schema}.dateformat_max(to_char(P1.CFM_DATE)) -- 确认日期
    ,${iml_schema}.dateformat_max(to_char(P1.EFFECT_DATE)) -- 保单生效日期
    ,P1.PAY_YEAR -- 支付周期
    ,NVL(TRIM(P1.INSURE_YEAR_TYPE),'-') -- 保险周期类型代码
    ,P1.INSURE_YEAR -- 保险周期
    ,NVL(TRIM(P1.PAY_TYPE),'-') -- 支付方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.PAY_YEAR_TYPE END -- 支付周期类型代码
    ,P1.AMT -- 交易金额
    ,P1.INSURE_FEE -- 保险费用
    ,P1.VOL -- 份额
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.STATUS -- 交易状态代码
    ,P1.HOLDER_NAME -- 持有人姓名
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.HOLDER_ID_TYPE END -- 持有人证件类型代码
    ,P1.HOLDER_ID_CODE -- 持有人证件号码
    ,P1.RELATION -- 关系类型代码
    ,P1.INSURED_NAME -- 被保险人姓名
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.INSURED_ID_TYPE END -- 被保险人证件类型代码
    ,P1.INSURED_ID_CODE -- 被保险人证件号码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbshareinsure' -- 源表名称
    ,'inssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.ifms_tbshareinsure p1
  left join iol.ifms_tbinsureproduct p2
    on p1.prd_code = p2.prd_code
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.ref_pub_cd_map r3
    on p1.pay_year_type = r3.src_code_val
   and r3.sorc_sys_cd = 'IFMS'
   and r3.src_tab_en_name = 'IFMS_TBSHAREINSURE'
   and r3.src_field_en_name = 'PAY_YEAR_TYPE'
   and r3.target_tab_en_name = 'AGT_INSURE_PL'
   and r3.target_tab_field_en_name = 'PAY_PED_TYPE_CD'
  left join ${iml_schema}.ref_pub_cd_map r1
    on p1.holder_id_type = r1.src_code_val
   and r1.sorc_sys_cd = 'IFMS'
   and r1.src_tab_en_name = 'IFMS_TBSHAREINSURE'
   and r1.src_field_en_name = 'HOLDER_ID_TYPE'
   and r1.target_tab_en_name = 'AGT_INSURE_PL'
   and r1.target_tab_field_en_name = 'HOLDER_CERT_TYPE_CD'
  left join ${iml_schema}.ref_pub_cd_map r2
    on p1.insured_id_type = r2.src_code_val
   and r2.sorc_sys_cd = 'IFMS'
   and r2.src_tab_en_name = 'IFMS_TBSHAREINSURE'
   and r2.src_field_en_name = 'INSURED_ID_TYPE'
   and r2.target_tab_en_name = 'AGT_INSURE_PL'
   and r2.target_tab_field_en_name = 'INSRT_CERT_TYPE_CD'
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_insure_pl_inssf1_tm 
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
        into ${iml_schema}.agt_insure_pl_inssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,insure_pl_id -- 保险单编号
    ,ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,bank_id -- 银行编号
    ,cust_mgr_id -- 客户经理编号
    ,cust_id -- 客户编号
    ,insure_print_id -- 保险打印单编号
    ,org_id -- 机构编号
    ,teller_id -- 柜员编号
    ,tran_dt -- 交易日期
    ,seq_num -- 序号
    ,policy_dt -- 保单日期
    ,cfm_dt -- 确认日期
    ,policy_effect_dt -- 保单生效日期
    ,pay_ped -- 支付周期
    ,insure_ped_type_cd -- 保险周期类型代码
    ,insure_ped -- 保险周期
    ,mode_pay_cd -- 支付方式代码
    ,pay_ped_type_cd -- 支付周期类型代码
    ,tran_amt -- 交易金额
    ,insure_fee -- 保险费用
    ,lot -- 份额
    ,bank_acct_id -- 银行账户编号
    ,tran_status_cd -- 交易状态代码
    ,holder_name -- 持有人姓名
    ,holder_cert_type_cd -- 持有人证件类型代码
    ,holder_cert_no -- 持有人证件号码
    ,rela_type_cd -- 关系类型代码
    ,insrt_name -- 被保险人姓名
    ,insrt_cert_type_cd -- 被保险人证件类型代码
    ,insrt_cert_no -- 被保险人证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_insure_pl_inssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,insure_pl_id -- 保险单编号
    ,ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,bank_id -- 银行编号
    ,cust_mgr_id -- 客户经理编号
    ,cust_id -- 客户编号
    ,insure_print_id -- 保险打印单编号
    ,org_id -- 机构编号
    ,teller_id -- 柜员编号
    ,tran_dt -- 交易日期
    ,seq_num -- 序号
    ,policy_dt -- 保单日期
    ,cfm_dt -- 确认日期
    ,policy_effect_dt -- 保单生效日期
    ,pay_ped -- 支付周期
    ,insure_ped_type_cd -- 保险周期类型代码
    ,insure_ped -- 保险周期
    ,mode_pay_cd -- 支付方式代码
    ,pay_ped_type_cd -- 支付周期类型代码
    ,tran_amt -- 交易金额
    ,insure_fee -- 保险费用
    ,lot -- 份额
    ,bank_acct_id -- 银行账户编号
    ,tran_status_cd -- 交易状态代码
    ,holder_name -- 持有人姓名
    ,holder_cert_type_cd -- 持有人证件类型代码
    ,holder_cert_no -- 持有人证件号码
    ,rela_type_cd -- 关系类型代码
    ,insrt_name -- 被保险人姓名
    ,insrt_cert_type_cd -- 被保险人证件类型代码
    ,insrt_cert_no -- 被保险人证件号码
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
    ,nvl(n.insure_pl_id, o.insure_pl_id) as insure_pl_id -- 保险单编号
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.bank_id, o.bank_id) as bank_id -- 银行编号
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.insure_print_id, o.insure_print_id) as insure_print_id -- 保险打印单编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.teller_id, o.teller_id) as teller_id -- 柜员编号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.policy_dt, o.policy_dt) as policy_dt -- 保单日期
    ,nvl(n.cfm_dt, o.cfm_dt) as cfm_dt -- 确认日期
    ,nvl(n.policy_effect_dt, o.policy_effect_dt) as policy_effect_dt -- 保单生效日期
    ,nvl(n.pay_ped, o.pay_ped) as pay_ped -- 支付周期
    ,nvl(n.insure_ped_type_cd, o.insure_ped_type_cd) as insure_ped_type_cd -- 保险周期类型代码
    ,nvl(n.insure_ped, o.insure_ped) as insure_ped -- 保险周期
    ,nvl(n.mode_pay_cd, o.mode_pay_cd) as mode_pay_cd -- 支付方式代码
    ,nvl(n.pay_ped_type_cd, o.pay_ped_type_cd) as pay_ped_type_cd -- 支付周期类型代码
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.insure_fee, o.insure_fee) as insure_fee -- 保险费用
    ,nvl(n.lot, o.lot) as lot -- 份额
    ,nvl(n.bank_acct_id, o.bank_acct_id) as bank_acct_id -- 银行账户编号
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.holder_name, o.holder_name) as holder_name -- 持有人姓名
    ,nvl(n.holder_cert_type_cd, o.holder_cert_type_cd) as holder_cert_type_cd -- 持有人证件类型代码
    ,nvl(n.holder_cert_no, o.holder_cert_no) as holder_cert_no -- 持有人证件号码
    ,nvl(n.rela_type_cd, o.rela_type_cd) as rela_type_cd -- 关系类型代码
    ,nvl(n.insrt_name, o.insrt_name) as insrt_name -- 被保险人姓名
    ,nvl(n.insrt_cert_type_cd, o.insrt_cert_type_cd) as insrt_cert_type_cd -- 被保险人证件类型代码
    ,nvl(n.insrt_cert_no, o.insrt_cert_no) as insrt_cert_no -- 被保险人证件号码
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
from ${iml_schema}.agt_insure_pl_inssf1_tm n
    full join (select * from ${iml_schema}.agt_insure_pl_inssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.insure_pl_id <> n.insure_pl_id
        or o.ta_cd <> n.ta_cd
        or o.prod_id <> n.prod_id
        or o.std_prod_id <> n.std_prod_id
        or o.bank_id <> n.bank_id
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.cust_id <> n.cust_id
        or o.insure_print_id <> n.insure_print_id
        or o.org_id <> n.org_id
        or o.teller_id <> n.teller_id
        or o.tran_dt <> n.tran_dt
        or o.seq_num <> n.seq_num
        or o.policy_dt <> n.policy_dt
        or o.cfm_dt <> n.cfm_dt
        or o.policy_effect_dt <> n.policy_effect_dt
        or o.pay_ped <> n.pay_ped
        or o.insure_ped_type_cd <> n.insure_ped_type_cd
        or o.insure_ped <> n.insure_ped
        or o.mode_pay_cd <> n.mode_pay_cd
        or o.pay_ped_type_cd <> n.pay_ped_type_cd
        or o.tran_amt <> n.tran_amt
        or o.insure_fee <> n.insure_fee
        or o.lot <> n.lot
        or o.bank_acct_id <> n.bank_acct_id
        or o.tran_status_cd <> n.tran_status_cd
        or o.holder_name <> n.holder_name
        or o.holder_cert_type_cd <> n.holder_cert_type_cd
        or o.holder_cert_no <> n.holder_cert_no
        or o.rela_type_cd <> n.rela_type_cd
        or o.insrt_name <> n.insrt_name
        or o.insrt_cert_type_cd <> n.insrt_cert_type_cd
        or o.insrt_cert_no <> n.insrt_cert_no
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_insure_pl_inssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,insure_pl_id -- 保险单编号
    ,ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,bank_id -- 银行编号
    ,cust_mgr_id -- 客户经理编号
    ,cust_id -- 客户编号
    ,insure_print_id -- 保险打印单编号
    ,org_id -- 机构编号
    ,teller_id -- 柜员编号
    ,tran_dt -- 交易日期
    ,seq_num -- 序号
    ,policy_dt -- 保单日期
    ,cfm_dt -- 确认日期
    ,policy_effect_dt -- 保单生效日期
    ,pay_ped -- 支付周期
    ,insure_ped_type_cd -- 保险周期类型代码
    ,insure_ped -- 保险周期
    ,mode_pay_cd -- 支付方式代码
    ,pay_ped_type_cd -- 支付周期类型代码
    ,tran_amt -- 交易金额
    ,insure_fee -- 保险费用
    ,lot -- 份额
    ,bank_acct_id -- 银行账户编号
    ,tran_status_cd -- 交易状态代码
    ,holder_name -- 持有人姓名
    ,holder_cert_type_cd -- 持有人证件类型代码
    ,holder_cert_no -- 持有人证件号码
    ,rela_type_cd -- 关系类型代码
    ,insrt_name -- 被保险人姓名
    ,insrt_cert_type_cd -- 被保险人证件类型代码
    ,insrt_cert_no -- 被保险人证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_insure_pl_inssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,insure_pl_id -- 保险单编号
    ,ta_cd -- TA代码
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,bank_id -- 银行编号
    ,cust_mgr_id -- 客户经理编号
    ,cust_id -- 客户编号
    ,insure_print_id -- 保险打印单编号
    ,org_id -- 机构编号
    ,teller_id -- 柜员编号
    ,tran_dt -- 交易日期
    ,seq_num -- 序号
    ,policy_dt -- 保单日期
    ,cfm_dt -- 确认日期
    ,policy_effect_dt -- 保单生效日期
    ,pay_ped -- 支付周期
    ,insure_ped_type_cd -- 保险周期类型代码
    ,insure_ped -- 保险周期
    ,mode_pay_cd -- 支付方式代码
    ,pay_ped_type_cd -- 支付周期类型代码
    ,tran_amt -- 交易金额
    ,insure_fee -- 保险费用
    ,lot -- 份额
    ,bank_acct_id -- 银行账户编号
    ,tran_status_cd -- 交易状态代码
    ,holder_name -- 持有人姓名
    ,holder_cert_type_cd -- 持有人证件类型代码
    ,holder_cert_no -- 持有人证件号码
    ,rela_type_cd -- 关系类型代码
    ,insrt_name -- 被保险人姓名
    ,insrt_cert_type_cd -- 被保险人证件类型代码
    ,insrt_cert_no -- 被保险人证件号码
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
    ,o.insure_pl_id -- 保险单编号
    ,o.ta_cd -- TA代码
    ,o.prod_id -- 产品编号
    ,o.std_prod_id -- 标准产品编号
    ,o.bank_id -- 银行编号
    ,o.cust_mgr_id -- 客户经理编号
    ,o.cust_id -- 客户编号
    ,o.insure_print_id -- 保险打印单编号
    ,o.org_id -- 机构编号
    ,o.teller_id -- 柜员编号
    ,o.tran_dt -- 交易日期
    ,o.seq_num -- 序号
    ,o.policy_dt -- 保单日期
    ,o.cfm_dt -- 确认日期
    ,o.policy_effect_dt -- 保单生效日期
    ,o.pay_ped -- 支付周期
    ,o.insure_ped_type_cd -- 保险周期类型代码
    ,o.insure_ped -- 保险周期
    ,o.mode_pay_cd -- 支付方式代码
    ,o.pay_ped_type_cd -- 支付周期类型代码
    ,o.tran_amt -- 交易金额
    ,o.insure_fee -- 保险费用
    ,o.lot -- 份额
    ,o.bank_acct_id -- 银行账户编号
    ,o.tran_status_cd -- 交易状态代码
    ,o.holder_name -- 持有人姓名
    ,o.holder_cert_type_cd -- 持有人证件类型代码
    ,o.holder_cert_no -- 持有人证件号码
    ,o.rela_type_cd -- 关系类型代码
    ,o.insrt_name -- 被保险人姓名
    ,o.insrt_cert_type_cd -- 被保险人证件类型代码
    ,o.insrt_cert_no -- 被保险人证件号码
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
from ${iml_schema}.agt_insure_pl_inssf1_bk o
    left join ${iml_schema}.agt_insure_pl_inssf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_insure_pl_inssf1_cl d
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
--truncate table ${iml_schema}.agt_insure_pl;
--alter table ${iml_schema}.agt_insure_pl truncate partition for ('inssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_insure_pl') 
               and substr(subpartition_name,1,8)=upper('p_inssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_insure_pl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_insure_pl modify partition p_inssf1 
add subpartition p_inssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_insure_pl exchange subpartition p_inssf1_${batch_date} with table ${iml_schema}.agt_insure_pl_inssf1_cl;
alter table ${iml_schema}.agt_insure_pl exchange subpartition p_inssf1_20991231 with table ${iml_schema}.agt_insure_pl_inssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_insure_pl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_insure_pl_inssf1_tm purge;
drop table ${iml_schema}.agt_insure_pl_inssf1_op purge;
drop table ${iml_schema}.agt_insure_pl_inssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_insure_pl_inssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_insure_pl', partname => 'p_inssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
