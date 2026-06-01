/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_payoff_sign_info_h_mpcsf1
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
alter table ${iml_schema}.agt_payoff_sign_info_h add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_payoff_sign_info_h partition for ('mpcsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_tm purge;
drop table ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_op purge;
drop table ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_id -- 签约编号
    ,sign_type_cd -- 签约类型代码
    ,entr_acct_id -- 委托账户编号
    ,entr_acct_name -- 委托账户名称
    ,tel_num -- 电话号码
    ,corp_addr -- 公司地址
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,bus_type_cd -- 业务类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,sign_dt -- 签约日期
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,agt_status_cd -- 协议状态代码
    ,cust_id -- 客户编号
    ,obank_flg -- 他行标志
    ,obank_acct_id -- 他行账户编号
    ,obank_acct_name -- 他行账户名称
    ,obank_bank_no -- 他行行号
    ,obank_bank_name -- 他行行名
    ,tran_inside_acct_id -- 过渡内部户账户编号
    ,tran_inside_acct_name -- 过渡内部户账户名称
    ,rfued_flg -- 退款中标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_payoff_sign_info_h partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_payoff_sign_info_h partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_payoff_sign_info_h partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a60projdf_sign-1
insert into ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_id -- 签约编号
    ,sign_type_cd -- 签约类型代码
    ,entr_acct_id -- 委托账户编号
    ,entr_acct_name -- 委托账户名称
    ,tel_num -- 电话号码
    ,corp_addr -- 公司地址
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,bus_type_cd -- 业务类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,sign_dt -- 签约日期
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,agt_status_cd -- 协议状态代码
    ,cust_id -- 客户编号
    ,obank_flg -- 他行标志
    ,obank_acct_id -- 他行账户编号
    ,obank_acct_name -- 他行账户名称
    ,obank_bank_no -- 他行行号
    ,obank_bank_name -- 他行行名
    ,tran_inside_acct_id -- 过渡内部户账户编号
    ,tran_inside_acct_name -- 过渡内部户账户名称
    ,rfued_flg -- 退款中标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '130022'||P1.PROJNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.PROJNO -- 签约编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PROJTP END -- 签约类型代码
    ,P1.ACCTNO -- 委托账户编号
    ,P1.ACCTNA -- 委托账户名称
    ,P1.OFFITL -- 电话号码
    ,P1.MAILAD -- 公司地址
    ,P1.GLACNO -- 内部账户编号
    ,P1.GLACNA -- 内部账户名称
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.BSTYPE END -- 业务类型代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ISNBNK END -- 交易渠道代码
    ,${iml_schema}.dateformat_max(P1.SIGNDT) -- 签约日期
    ,P1.CNTRBR -- 签约机构编号
    ,P1.CRTRUS -- 签约柜员编号
    ,${iml_schema}.dateformat_max2(P1.CLOSDT) -- 解约日期
    ,P1.CLOSUS -- 解约柜员编号
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.CNTRST END -- 协议状态代码
    ,P1.CUSTNO -- 客户编号
    ,P1.OTHERFLAG -- 他行标志
    ,P1.OTHERACCTNO -- 他行账户编号
    ,P1.OTHERACCTNA -- 他行账户名称
    ,P1.OTHERBANKNO -- 他行行号
    ,P1.OTHERBANKNA -- 他行行名
    ,P1.INNERACNO -- 过渡内部户账户编号
    ,P1.INNERACNA -- 过渡内部户账户名称
    ,P1.TKFLAG -- 退款中标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a60projdf_sign' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a60projdf_sign p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PROJTP = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A60PROJDF_SIGN'
        AND R1.SRC_FIELD_EN_NAME= 'PROJTP'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_PAYOFF_SIGN_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'SIGN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.BSTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A60PROJDF_SIGN'
        AND R2.SRC_FIELD_EN_NAME= 'BSTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_PAYOFF_SIGN_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BUS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ISNBNK = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A60PROJDF_SIGN'
        AND R3.SRC_FIELD_EN_NAME= 'ISNBNK'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_PAYOFF_SIGN_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_CHN_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.CNTRST = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A60PROJDF_SIGN'
        AND R4.SRC_FIELD_EN_NAME= 'CNTRST'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_PAYOFF_SIGN_INFO_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'AGT_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_tm 
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
        into ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_id -- 签约编号
    ,sign_type_cd -- 签约类型代码
    ,entr_acct_id -- 委托账户编号
    ,entr_acct_name -- 委托账户名称
    ,tel_num -- 电话号码
    ,corp_addr -- 公司地址
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,bus_type_cd -- 业务类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,sign_dt -- 签约日期
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,agt_status_cd -- 协议状态代码
    ,cust_id -- 客户编号
    ,obank_flg -- 他行标志
    ,obank_acct_id -- 他行账户编号
    ,obank_acct_name -- 他行账户名称
    ,obank_bank_no -- 他行行号
    ,obank_bank_name -- 他行行名
    ,tran_inside_acct_id -- 过渡内部户账户编号
    ,tran_inside_acct_name -- 过渡内部户账户名称
    ,rfued_flg -- 退款中标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_id -- 签约编号
    ,sign_type_cd -- 签约类型代码
    ,entr_acct_id -- 委托账户编号
    ,entr_acct_name -- 委托账户名称
    ,tel_num -- 电话号码
    ,corp_addr -- 公司地址
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,bus_type_cd -- 业务类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,sign_dt -- 签约日期
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,agt_status_cd -- 协议状态代码
    ,cust_id -- 客户编号
    ,obank_flg -- 他行标志
    ,obank_acct_id -- 他行账户编号
    ,obank_acct_name -- 他行账户名称
    ,obank_bank_no -- 他行行号
    ,obank_bank_name -- 他行行名
    ,tran_inside_acct_id -- 过渡内部户账户编号
    ,tran_inside_acct_name -- 过渡内部户账户名称
    ,rfued_flg -- 退款中标志
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
    ,nvl(n.sign_id, o.sign_id) as sign_id -- 签约编号
    ,nvl(n.sign_type_cd, o.sign_type_cd) as sign_type_cd -- 签约类型代码
    ,nvl(n.entr_acct_id, o.entr_acct_id) as entr_acct_id -- 委托账户编号
    ,nvl(n.entr_acct_name, o.entr_acct_name) as entr_acct_name -- 委托账户名称
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 电话号码
    ,nvl(n.corp_addr, o.corp_addr) as corp_addr -- 公司地址
    ,nvl(n.intnal_acct_id, o.intnal_acct_id) as intnal_acct_id -- 内部账户编号
    ,nvl(n.intnal_acct_name, o.intnal_acct_name) as intnal_acct_name -- 内部账户名称
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.tran_chn_cd, o.tran_chn_cd) as tran_chn_cd -- 交易渠道代码
    ,nvl(n.sign_dt, o.sign_dt) as sign_dt -- 签约日期
    ,nvl(n.sign_org_id, o.sign_org_id) as sign_org_id -- 签约机构编号
    ,nvl(n.sign_teller_id, o.sign_teller_id) as sign_teller_id -- 签约柜员编号
    ,nvl(n.rels_dt, o.rels_dt) as rels_dt -- 解约日期
    ,nvl(n.rels_teller_id, o.rels_teller_id) as rels_teller_id -- 解约柜员编号
    ,nvl(n.agt_status_cd, o.agt_status_cd) as agt_status_cd -- 协议状态代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.obank_flg, o.obank_flg) as obank_flg -- 他行标志
    ,nvl(n.obank_acct_id, o.obank_acct_id) as obank_acct_id -- 他行账户编号
    ,nvl(n.obank_acct_name, o.obank_acct_name) as obank_acct_name -- 他行账户名称
    ,nvl(n.obank_bank_no, o.obank_bank_no) as obank_bank_no -- 他行行号
    ,nvl(n.obank_bank_name, o.obank_bank_name) as obank_bank_name -- 他行行名
    ,nvl(n.tran_inside_acct_id, o.tran_inside_acct_id) as tran_inside_acct_id -- 过渡内部户账户编号
    ,nvl(n.tran_inside_acct_name, o.tran_inside_acct_name) as tran_inside_acct_name -- 过渡内部户账户名称
    ,nvl(n.rfued_flg, o.rfued_flg) as rfued_flg -- 退款中标志
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
from ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_tm n
    full join (select * from ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.sign_id <> n.sign_id
        or o.sign_type_cd <> n.sign_type_cd
        or o.entr_acct_id <> n.entr_acct_id
        or o.entr_acct_name <> n.entr_acct_name
        or o.tel_num <> n.tel_num
        or o.corp_addr <> n.corp_addr
        or o.intnal_acct_id <> n.intnal_acct_id
        or o.intnal_acct_name <> n.intnal_acct_name
        or o.bus_type_cd <> n.bus_type_cd
        or o.tran_chn_cd <> n.tran_chn_cd
        or o.sign_dt <> n.sign_dt
        or o.sign_org_id <> n.sign_org_id
        or o.sign_teller_id <> n.sign_teller_id
        or o.rels_dt <> n.rels_dt
        or o.rels_teller_id <> n.rels_teller_id
        or o.agt_status_cd <> n.agt_status_cd
        or o.cust_id <> n.cust_id
        or o.obank_flg <> n.obank_flg
        or o.obank_acct_id <> n.obank_acct_id
        or o.obank_acct_name <> n.obank_acct_name
        or o.obank_bank_no <> n.obank_bank_no
        or o.obank_bank_name <> n.obank_bank_name
        or o.tran_inside_acct_id <> n.tran_inside_acct_id
        or o.tran_inside_acct_name <> n.tran_inside_acct_name
        or o.rfued_flg <> n.rfued_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_id -- 签约编号
    ,sign_type_cd -- 签约类型代码
    ,entr_acct_id -- 委托账户编号
    ,entr_acct_name -- 委托账户名称
    ,tel_num -- 电话号码
    ,corp_addr -- 公司地址
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,bus_type_cd -- 业务类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,sign_dt -- 签约日期
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,agt_status_cd -- 协议状态代码
    ,cust_id -- 客户编号
    ,obank_flg -- 他行标志
    ,obank_acct_id -- 他行账户编号
    ,obank_acct_name -- 他行账户名称
    ,obank_bank_no -- 他行行号
    ,obank_bank_name -- 他行行名
    ,tran_inside_acct_id -- 过渡内部户账户编号
    ,tran_inside_acct_name -- 过渡内部户账户名称
    ,rfued_flg -- 退款中标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_id -- 签约编号
    ,sign_type_cd -- 签约类型代码
    ,entr_acct_id -- 委托账户编号
    ,entr_acct_name -- 委托账户名称
    ,tel_num -- 电话号码
    ,corp_addr -- 公司地址
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,bus_type_cd -- 业务类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,sign_dt -- 签约日期
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,agt_status_cd -- 协议状态代码
    ,cust_id -- 客户编号
    ,obank_flg -- 他行标志
    ,obank_acct_id -- 他行账户编号
    ,obank_acct_name -- 他行账户名称
    ,obank_bank_no -- 他行行号
    ,obank_bank_name -- 他行行名
    ,tran_inside_acct_id -- 过渡内部户账户编号
    ,tran_inside_acct_name -- 过渡内部户账户名称
    ,rfued_flg -- 退款中标志
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
    ,o.sign_id -- 签约编号
    ,o.sign_type_cd -- 签约类型代码
    ,o.entr_acct_id -- 委托账户编号
    ,o.entr_acct_name -- 委托账户名称
    ,o.tel_num -- 电话号码
    ,o.corp_addr -- 公司地址
    ,o.intnal_acct_id -- 内部账户编号
    ,o.intnal_acct_name -- 内部账户名称
    ,o.bus_type_cd -- 业务类型代码
    ,o.tran_chn_cd -- 交易渠道代码
    ,o.sign_dt -- 签约日期
    ,o.sign_org_id -- 签约机构编号
    ,o.sign_teller_id -- 签约柜员编号
    ,o.rels_dt -- 解约日期
    ,o.rels_teller_id -- 解约柜员编号
    ,o.agt_status_cd -- 协议状态代码
    ,o.cust_id -- 客户编号
    ,o.obank_flg -- 他行标志
    ,o.obank_acct_id -- 他行账户编号
    ,o.obank_acct_name -- 他行账户名称
    ,o.obank_bank_no -- 他行行号
    ,o.obank_bank_name -- 他行行名
    ,o.tran_inside_acct_id -- 过渡内部户账户编号
    ,o.tran_inside_acct_name -- 过渡内部户账户名称
    ,o.rfued_flg -- 退款中标志
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
from ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_bk o
    left join ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_cl d
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
--truncate table ${iml_schema}.agt_payoff_sign_info_h;
--alter table ${iml_schema}.agt_payoff_sign_info_h truncate partition for ('mpcsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_payoff_sign_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mpcsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_payoff_sign_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_payoff_sign_info_h modify partition p_mpcsf1 
add subpartition p_mpcsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_payoff_sign_info_h exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_cl;
alter table ${iml_schema}.agt_payoff_sign_info_h exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_payoff_sign_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_tm purge;
drop table ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_op purge;
drop table ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_payoff_sign_info_h_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_payoff_sign_info_h', partname => 'p_mpcsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
