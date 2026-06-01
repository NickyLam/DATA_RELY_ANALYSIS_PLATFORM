/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ant_wrt_off_dubil_myhxf1
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
drop table ${iml_schema}.agt_ant_wrt_off_dubil_myhxf1_tm purge;
drop table ${iml_schema}.agt_ant_wrt_off_dubil_myhxf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_ant_wrt_off_dubil add partition p_myhxf1 values ('myhxf1')(
        subpartition p_myhxf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_ant_wrt_off_dubil modify partition p_myhxf1
    add subpartition p_myhxf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ant_wrt_off_dubil_myhxf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ant_wrt_off_dubil partition for ('myhxf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ant_wrt_off_dubil_myhxf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,cust_id -- 客户编号
    ,dubil_amt -- 借据金额
    ,curr_bal -- 当前余额
    ,exp_dt -- 到期日期
    ,exec_int_rat -- 执行利率
    ,ovdue_days -- 贷款逾期天数
    ,int -- 利息
    ,pnlt -- 罚息
    ,repay_way_cd -- 还款方式代码
    ,tenor -- 期限
    ,acct_instit_id -- 账务机构编号
    ,wrt_off_status_cd -- 核销状态代码
    ,bus_type_cd -- 业务类型代码
    ,distr_dt -- 放款日期
    ,ovdue_dt -- 逾期日期
    ,coll_cnt -- 催收次数
    ,insto_dt -- 入库日期
    ,fir_wrt_off_dt -- 首次核销日期
    ,recvbl_pric -- 应收本金
    ,recvbl_off_bs_int -- 应收表外利息
    ,remark -- 备注
    ,level5_cls_cd -- 五级分类代码
    ,advc_fee -- 垫付费用
    ,cust_name -- 客户名称
    ,gender_cd -- 性别代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,insto_batch_no -- 入库批次号
    ,dubil_type_cd -- 借据类型代码
    ,loan_bal -- 贷款余额
    ,dep_bal -- 存款余额
    ,wrt_off_in_bs_int -- 核销表内利息
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ant_wrt_off_dubil
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_ant_wrt_off_dubil_myhxf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_ant_wrt_off_dubil partition for ('myhxf1') where 0=1;

-- 2.1 insert data to tm table
-- icms_afterloan_write_off_duebill-
insert into ${iml_schema}.agt_ant_wrt_off_dubil_myhxf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,cust_id -- 客户编号
    ,dubil_amt -- 借据金额
    ,curr_bal -- 当前余额
    ,exp_dt -- 到期日期
    ,exec_int_rat -- 执行利率
    ,ovdue_days -- 贷款逾期天数
    ,int -- 利息
    ,pnlt -- 罚息
    ,repay_way_cd -- 还款方式代码
    ,tenor -- 期限
    ,acct_instit_id -- 账务机构编号
    ,wrt_off_status_cd -- 核销状态代码
    ,bus_type_cd -- 业务类型代码
    ,distr_dt -- 放款日期
    ,ovdue_dt -- 逾期日期
    ,coll_cnt -- 催收次数
    ,insto_dt -- 入库日期
    ,fir_wrt_off_dt -- 首次核销日期
    ,recvbl_pric -- 应收本金
    ,recvbl_off_bs_int -- 应收表外利息
    ,remark -- 备注
    ,level5_cls_cd -- 五级分类代码
    ,advc_fee -- 垫付费用
    ,cust_name -- 客户名称
    ,gender_cd -- 性别代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,insto_batch_no -- 入库批次号
    ,dubil_type_cd -- 借据类型代码
    ,loan_bal -- 贷款余额
    ,dep_bal -- 存款余额
    ,wrt_off_in_bs_int -- 核销表内利息
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    CASE WHEN P1.BUSINESSTYPE = '4' THEN '222630'||TRIM(P1.BDSERIALNO)
     WHEN (P1.BUSINESSTYPE = '1' or P1.BUSINESSTYPE = '2') THEN '222620'||TRIM(P1.BDSERIALNO)
     WHEN P1.BUSINESSTYPE = '3' THEN '222610'||TRIM(P1.BDSERIALNO)
     ELSE P1.BDSERIALNO
END -- 协议编号
    ,'9999' -- 法人编号
    ,P1.BDSERIALNO -- 借据编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.BUSINESSSUM -- 借据金额
    ,P1.BALANCE -- 当前余额
    ,P1.MATURITY -- 到期日期
    ,P1.EXECUTERATE * 100 -- 执行利率
    ,P1.OVERDUEDAYS -- 贷款逾期天数
    ,P1.OVERDUEINTEREST -- 利息
    ,P1.CAPITALPENALTYBALANCE -- 罚息
    ,nvl(trim(P1.REPAYTYPE),'-') -- 还款方式代码
    ,P1.TERMMONTH -- 期限
    ,P1.FINABRID -- 账务机构编号
    ,nvl(trim(P1.WRITEOFFSTATUS),'-')  -- 核销状态代码
    ,nvl(trim(P1.BUSINESSTYPE),'-') -- 业务类型代码
    ,P1.STARTDATE -- 放款日期
    ,P1.ENDDATE -- 逾期日期
    ,nvl(trim（P1.COLLECTIONNUM）,0) -- 催收次数
    ,P1.INBOUNDDATE -- 入库日期
    ,CASE WHEN P1.WRITEOFFDATE > TO_DATE('00010101','YYYYMMDD')  AND P1.WRITEOFFDATE <= to_date('${batch_date}','yyyy-mm-dd') THEN P1.WRITEOFFDATE
     WHEN P1.WRITEOFFSTATUS = '01' THEN ${iml_schema}.dateformat_min(NULL)
     ELSE ${iml_schema}.dateformat_max2(NULL)
END -- 首次核销日期
    ,P1.ACTLWRITEOFFLOANPRCP -- 应收本金
    ,P1.ACTLWRITEOFFOFFINT -- 应收表外利息
    ,P1.REMARK -- 备注
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.FIVERISKCLA END -- 五级分类代码
    ,P1.ADVANCEPAYMENT -- 垫付费用
    ,P1.CUSTOMERNAME -- 客户名称
    ,nvl(trim(P1.SEX),'0') -- 性别代码
    ,nvl(trim(P1.CERTTYPE),'0000') -- 证件类型代码
    ,P1.CERTID -- 证件号码
    ,P1.INBOUNDBATNO -- 入库批次号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.BILLTYPE END -- 借据类型代码
    ,P1.LOANSUM -- 贷款余额
    ,P1.LOANBALANCE -- 存款余额
    ,P1.ACTLWRITEOFFININT -- 核销表内利息
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_afterloan_write_off_duebill' -- 源表名称
    ,'myhxf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_afterloan_write_off_duebill p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.FIVERISKCLA = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_AFTERLOAN_WRITE_OFF_DUEBILL'
        AND R2.SRC_FIELD_EN_NAME= 'FIVERISKCLA'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_ANT_WRT_OFF_DUBIL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'LEVEL5_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.BILLTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ICMS'
        AND R3.SRC_TAB_EN_NAME= 'ICMS_AFTERLOAN_WRITE_OFF_DUEBILL'
        AND R3.SRC_FIELD_EN_NAME= 'BILLTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_ANT_WRT_OFF_DUBIL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'DUBIL_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ant_wrt_off_dubil_myhxf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_ant_wrt_off_dubil_myhxf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,cust_id -- 客户编号
    ,dubil_amt -- 借据金额
    ,curr_bal -- 当前余额
    ,exp_dt -- 到期日期
    ,exec_int_rat -- 执行利率
    ,ovdue_days -- 贷款逾期天数
    ,int -- 利息
    ,pnlt -- 罚息
    ,repay_way_cd -- 还款方式代码
    ,tenor -- 期限
    ,acct_instit_id -- 账务机构编号
    ,wrt_off_status_cd -- 核销状态代码
    ,bus_type_cd -- 业务类型代码
    ,distr_dt -- 放款日期
    ,ovdue_dt -- 逾期日期
    ,coll_cnt -- 催收次数
    ,insto_dt -- 入库日期
    ,fir_wrt_off_dt -- 首次核销日期
    ,recvbl_pric -- 应收本金
    ,recvbl_off_bs_int -- 应收表外利息
    ,remark -- 备注
    ,level5_cls_cd -- 五级分类代码
    ,advc_fee -- 垫付费用
    ,cust_name -- 客户名称
    ,gender_cd -- 性别代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,insto_batch_no -- 入库批次号
    ,dubil_type_cd -- 借据类型代码
    ,loan_bal -- 贷款余额
    ,dep_bal -- 存款余额
    ,wrt_off_in_bs_int -- 核销表内利息
    ,final_update_dt -- 最后更新日期
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
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.dubil_amt, o.dubil_amt) as dubil_amt -- 借据金额
    ,nvl(n.curr_bal, o.curr_bal) as curr_bal -- 当前余额
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.ovdue_days, o.ovdue_days) as ovdue_days -- 贷款逾期天数
    ,nvl(n.int, o.int) as int -- 利息
    ,nvl(n.pnlt, o.pnlt) as pnlt -- 罚息
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.tenor, o.tenor) as tenor -- 期限
    ,nvl(n.acct_instit_id, o.acct_instit_id) as acct_instit_id -- 账务机构编号
    ,nvl(n.wrt_off_status_cd, o.wrt_off_status_cd) as wrt_off_status_cd -- 核销状态代码
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.distr_dt, o.distr_dt) as distr_dt -- 放款日期
    ,nvl(n.ovdue_dt, o.ovdue_dt) as ovdue_dt -- 逾期日期
    ,nvl(n.coll_cnt, o.coll_cnt) as coll_cnt -- 催收次数
    ,nvl(n.insto_dt, o.insto_dt) as insto_dt -- 入库日期
    ,nvl(n.fir_wrt_off_dt, o.fir_wrt_off_dt) as fir_wrt_off_dt -- 首次核销日期
    ,nvl(n.recvbl_pric, o.recvbl_pric) as recvbl_pric -- 应收本金
    ,nvl(n.recvbl_off_bs_int, o.recvbl_off_bs_int) as recvbl_off_bs_int -- 应收表外利息
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.level5_cls_cd, o.level5_cls_cd) as level5_cls_cd -- 五级分类代码
    ,nvl(n.advc_fee, o.advc_fee) as advc_fee -- 垫付费用
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别代码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.insto_batch_no, o.insto_batch_no) as insto_batch_no -- 入库批次号
    ,nvl(n.dubil_type_cd, o.dubil_type_cd) as dubil_type_cd -- 借据类型代码
    ,nvl(n.loan_bal, o.loan_bal) as loan_bal -- 贷款余额
    ,nvl(n.dep_bal, o.dep_bal) as dep_bal -- 存款余额
    ,nvl(n.wrt_off_in_bs_int, o.wrt_off_in_bs_int) as wrt_off_in_bs_int -- 核销表内利息
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.dubil_id <> n.dubil_id
                or o.cust_id <> n.cust_id
                or o.dubil_amt <> n.dubil_amt
                or o.curr_bal <> n.curr_bal
                or o.exp_dt <> n.exp_dt
                or o.exec_int_rat <> n.exec_int_rat
                or o.ovdue_days <> n.ovdue_days
                or o.int <> n.int
                or o.pnlt <> n.pnlt
                or o.repay_way_cd <> n.repay_way_cd
                or o.tenor <> n.tenor
                or o.acct_instit_id <> n.acct_instit_id
                or o.wrt_off_status_cd <> n.wrt_off_status_cd
                or o.bus_type_cd <> n.bus_type_cd
                or o.distr_dt <> n.distr_dt
                or o.ovdue_dt <> n.ovdue_dt
                or o.coll_cnt <> n.coll_cnt
                or o.insto_dt <> n.insto_dt
                or o.fir_wrt_off_dt <> n.fir_wrt_off_dt
                or o.recvbl_pric <> n.recvbl_pric
                or o.recvbl_off_bs_int <> n.recvbl_off_bs_int
                or o.remark <> n.remark
                or o.level5_cls_cd <> n.level5_cls_cd
                or o.advc_fee <> n.advc_fee
                or o.cust_name <> n.cust_name
                or o.gender_cd <> n.gender_cd
                or o.cert_type_cd <> n.cert_type_cd
                or o.cert_no <> n.cert_no
                or o.insto_batch_no <> n.insto_batch_no
                or o.dubil_type_cd <> n.dubil_type_cd
                or o.loan_bal <> n.loan_bal
                or o.dep_bal <> n.dep_bal
                or o.wrt_off_in_bs_int <> n.wrt_off_in_bs_int
                or o.final_update_dt <> n.final_update_dt
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
from ${iml_schema}.agt_ant_wrt_off_dubil_myhxf1_tm n
    full join ${iml_schema}.agt_ant_wrt_off_dubil_myhxf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_ant_wrt_off_dubil truncate partition for ('myhxf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_ant_wrt_off_dubil exchange subpartition p_myhxf1_${batch_date} with table ${iml_schema}.agt_ant_wrt_off_dubil_myhxf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ant_wrt_off_dubil drop subpartition p_myhxf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ant_wrt_off_dubil to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_ant_wrt_off_dubil_myhxf1_tm purge;
drop table ${iml_schema}.agt_ant_wrt_off_dubil_myhxf1_ex purge;
drop table ${iml_schema}.agt_ant_wrt_off_dubil_myhxf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ant_wrt_off_dubil', partname => 'p_myhxf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);