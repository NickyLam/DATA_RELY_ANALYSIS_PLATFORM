/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_reg_debit_crdt_sign_h_mpcsf1
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
alter table ${iml_schema}.agt_reg_debit_crdt_sign_h add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_reg_debit_crdt_sign_h partition for ('mpcsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_tm purge;
drop table ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_op purge;
drop table ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,sign_corp_id -- 签约单位编号
    ,cont_seq_num -- 合同顺序号
    ,city_cd -- 所在城市代码
    ,cont_type_cd -- 合同类型代码
    ,bus_type_cd -- 业务类型代码
    ,bus_kind_cd -- 业务种类代码
    ,cont_status_cd -- 合同状态代码
    ,obank_init_flg -- 他行发起标志
    ,obank_no -- 他行行号
    ,obank_name -- 他行行名
    ,obank_acct_num -- 他行账号
    ,obank_acct_name -- 他行户名
    ,ghb_bank_no -- 本行行号
    ,ghb_bank_name -- 本行行名
    ,ghb_acct_num -- 本行账号
    ,ghb_acct_name -- 本行户名
    ,cont_sign_dt -- 合同签订日期
    ,cont_revo_dt -- 合同撤销日期
    ,teller_id -- 柜员编号
    ,org_id -- 机构编号
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_reg_debit_crdt_sign_h partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_reg_debit_crdt_sign_h partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_reg_debit_crdt_sign_h partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a08tbefixsign-
insert into ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,sign_corp_id -- 签约单位编号
    ,cont_seq_num -- 合同顺序号
    ,city_cd -- 所在城市代码
    ,cont_type_cd -- 合同类型代码
    ,bus_type_cd -- 业务类型代码
    ,bus_kind_cd -- 业务种类代码
    ,cont_status_cd -- 合同状态代码
    ,obank_init_flg -- 他行发起标志
    ,obank_no -- 他行行号
    ,obank_name -- 他行行名
    ,obank_acct_num -- 他行账号
    ,obank_acct_name -- 他行户名
    ,ghb_bank_no -- 本行行号
    ,ghb_bank_name -- 本行行名
    ,ghb_acct_num -- 本行账号
    ,ghb_acct_name -- 本行户名
    ,cont_sign_dt -- 合同签订日期
    ,cont_revo_dt -- 合同撤销日期
    ,teller_id -- 柜员编号
    ,org_id -- 机构编号
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '130026'||P1.CNTRNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CNTRNO -- 合同编号
    ,P1.UNITCD -- 签约单位编号
    ,P1.CNTRSQ -- 合同顺序号
    ,P1.CITYCD -- 所在城市代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CNTRTP END -- 合同类型代码
    ,P1.BUSTYPE -- 业务类型代码
    ,P1.SERVTYPE -- 业务种类代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CNTRST END -- 合同状态代码
    ,NVL(TRIM(P1.IOTYPE),'-') -- 他行发起标志
    ,P1.RECVBK -- 他行行号
    ,P1.REBKNA -- 他行行名
    ,P1.RECVAC -- 他行账号
    ,P1.RECVNA -- 他行户名
    ,P1.PYERBK -- 本行行号
    ,P1.PYBKNA -- 本行行名
    ,P1.PYERAC -- 本行账号
    ,P1.PYERNA -- 本行户名
    ,${iml_schema}.DATEFORMAT_MIN(P1.SIGNDT) -- 合同签订日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.CNCLDT) -- 合同撤销日期
    ,P1.USERID -- 柜员编号
    ,P1.BRCHNO -- 机构编号
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a08tbefixsign' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a08tbefixsign p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CNTRTP = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A08TBEFIXSIGN'
        AND R1.SRC_FIELD_EN_NAME= 'CNTRTP'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_REG_DEBIT_CRDT_SIGN_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CONT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CNTRST = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A08TBEFIXSIGN'
        AND R2.SRC_FIELD_EN_NAME= 'CNTRST'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_REG_DEBIT_CRDT_SIGN_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CONT_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,sign_corp_id -- 签约单位编号
    ,cont_seq_num -- 合同顺序号
    ,city_cd -- 所在城市代码
    ,cont_type_cd -- 合同类型代码
    ,bus_type_cd -- 业务类型代码
    ,bus_kind_cd -- 业务种类代码
    ,cont_status_cd -- 合同状态代码
    ,obank_init_flg -- 他行发起标志
    ,obank_no -- 他行行号
    ,obank_name -- 他行行名
    ,obank_acct_num -- 他行账号
    ,obank_acct_name -- 他行户名
    ,ghb_bank_no -- 本行行号
    ,ghb_bank_name -- 本行行名
    ,ghb_acct_num -- 本行账号
    ,ghb_acct_name -- 本行户名
    ,cont_sign_dt -- 合同签订日期
    ,cont_revo_dt -- 合同撤销日期
    ,teller_id -- 柜员编号
    ,org_id -- 机构编号
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,sign_corp_id -- 签约单位编号
    ,cont_seq_num -- 合同顺序号
    ,city_cd -- 所在城市代码
    ,cont_type_cd -- 合同类型代码
    ,bus_type_cd -- 业务类型代码
    ,bus_kind_cd -- 业务种类代码
    ,cont_status_cd -- 合同状态代码
    ,obank_init_flg -- 他行发起标志
    ,obank_no -- 他行行号
    ,obank_name -- 他行行名
    ,obank_acct_num -- 他行账号
    ,obank_acct_name -- 他行户名
    ,ghb_bank_no -- 本行行号
    ,ghb_bank_name -- 本行行名
    ,ghb_acct_num -- 本行账号
    ,ghb_acct_name -- 本行户名
    ,cont_sign_dt -- 合同签订日期
    ,cont_revo_dt -- 合同撤销日期
    ,teller_id -- 柜员编号
    ,org_id -- 机构编号
    ,remark -- 备注
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
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.sign_corp_id, o.sign_corp_id) as sign_corp_id -- 签约单位编号
    ,nvl(n.cont_seq_num, o.cont_seq_num) as cont_seq_num -- 合同顺序号
    ,nvl(n.city_cd, o.city_cd) as city_cd -- 所在城市代码
    ,nvl(n.cont_type_cd, o.cont_type_cd) as cont_type_cd -- 合同类型代码
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.bus_kind_cd, o.bus_kind_cd) as bus_kind_cd -- 业务种类代码
    ,nvl(n.cont_status_cd, o.cont_status_cd) as cont_status_cd -- 合同状态代码
    ,nvl(n.obank_init_flg, o.obank_init_flg) as obank_init_flg -- 他行发起标志
    ,nvl(n.obank_no, o.obank_no) as obank_no -- 他行行号
    ,nvl(n.obank_name, o.obank_name) as obank_name -- 他行行名
    ,nvl(n.obank_acct_num, o.obank_acct_num) as obank_acct_num -- 他行账号
    ,nvl(n.obank_acct_name, o.obank_acct_name) as obank_acct_name -- 他行户名
    ,nvl(n.ghb_bank_no, o.ghb_bank_no) as ghb_bank_no -- 本行行号
    ,nvl(n.ghb_bank_name, o.ghb_bank_name) as ghb_bank_name -- 本行行名
    ,nvl(n.ghb_acct_num, o.ghb_acct_num) as ghb_acct_num -- 本行账号
    ,nvl(n.ghb_acct_name, o.ghb_acct_name) as ghb_acct_name -- 本行户名
    ,nvl(n.cont_sign_dt, o.cont_sign_dt) as cont_sign_dt -- 合同签订日期
    ,nvl(n.cont_revo_dt, o.cont_revo_dt) as cont_revo_dt -- 合同撤销日期
    ,nvl(n.teller_id, o.teller_id) as teller_id -- 柜员编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.remark, o.remark) as remark -- 备注
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
from ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_tm n
    full join (select * from ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.cont_id <> n.cont_id
        or o.sign_corp_id <> n.sign_corp_id
        or o.cont_seq_num <> n.cont_seq_num
        or o.city_cd <> n.city_cd
        or o.cont_type_cd <> n.cont_type_cd
        or o.bus_type_cd <> n.bus_type_cd
        or o.bus_kind_cd <> n.bus_kind_cd
        or o.cont_status_cd <> n.cont_status_cd
        or o.obank_init_flg <> n.obank_init_flg
        or o.obank_no <> n.obank_no
        or o.obank_name <> n.obank_name
        or o.obank_acct_num <> n.obank_acct_num
        or o.obank_acct_name <> n.obank_acct_name
        or o.ghb_bank_no <> n.ghb_bank_no
        or o.ghb_bank_name <> n.ghb_bank_name
        or o.ghb_acct_num <> n.ghb_acct_num
        or o.ghb_acct_name <> n.ghb_acct_name
        or o.cont_sign_dt <> n.cont_sign_dt
        or o.cont_revo_dt <> n.cont_revo_dt
        or o.teller_id <> n.teller_id
        or o.org_id <> n.org_id
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,sign_corp_id -- 签约单位编号
    ,cont_seq_num -- 合同顺序号
    ,city_cd -- 所在城市代码
    ,cont_type_cd -- 合同类型代码
    ,bus_type_cd -- 业务类型代码
    ,bus_kind_cd -- 业务种类代码
    ,cont_status_cd -- 合同状态代码
    ,obank_init_flg -- 他行发起标志
    ,obank_no -- 他行行号
    ,obank_name -- 他行行名
    ,obank_acct_num -- 他行账号
    ,obank_acct_name -- 他行户名
    ,ghb_bank_no -- 本行行号
    ,ghb_bank_name -- 本行行名
    ,ghb_acct_num -- 本行账号
    ,ghb_acct_name -- 本行户名
    ,cont_sign_dt -- 合同签订日期
    ,cont_revo_dt -- 合同撤销日期
    ,teller_id -- 柜员编号
    ,org_id -- 机构编号
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,sign_corp_id -- 签约单位编号
    ,cont_seq_num -- 合同顺序号
    ,city_cd -- 所在城市代码
    ,cont_type_cd -- 合同类型代码
    ,bus_type_cd -- 业务类型代码
    ,bus_kind_cd -- 业务种类代码
    ,cont_status_cd -- 合同状态代码
    ,obank_init_flg -- 他行发起标志
    ,obank_no -- 他行行号
    ,obank_name -- 他行行名
    ,obank_acct_num -- 他行账号
    ,obank_acct_name -- 他行户名
    ,ghb_bank_no -- 本行行号
    ,ghb_bank_name -- 本行行名
    ,ghb_acct_num -- 本行账号
    ,ghb_acct_name -- 本行户名
    ,cont_sign_dt -- 合同签订日期
    ,cont_revo_dt -- 合同撤销日期
    ,teller_id -- 柜员编号
    ,org_id -- 机构编号
    ,remark -- 备注
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
    ,o.cont_id -- 合同编号
    ,o.sign_corp_id -- 签约单位编号
    ,o.cont_seq_num -- 合同顺序号
    ,o.city_cd -- 所在城市代码
    ,o.cont_type_cd -- 合同类型代码
    ,o.bus_type_cd -- 业务类型代码
    ,o.bus_kind_cd -- 业务种类代码
    ,o.cont_status_cd -- 合同状态代码
    ,o.obank_init_flg -- 他行发起标志
    ,o.obank_no -- 他行行号
    ,o.obank_name -- 他行行名
    ,o.obank_acct_num -- 他行账号
    ,o.obank_acct_name -- 他行户名
    ,o.ghb_bank_no -- 本行行号
    ,o.ghb_bank_name -- 本行行名
    ,o.ghb_acct_num -- 本行账号
    ,o.ghb_acct_name -- 本行户名
    ,o.cont_sign_dt -- 合同签订日期
    ,o.cont_revo_dt -- 合同撤销日期
    ,o.teller_id -- 柜员编号
    ,o.org_id -- 机构编号
    ,o.remark -- 备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_bk o
    left join ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_cl d
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
--truncate table ${iml_schema}.agt_reg_debit_crdt_sign_h;
alter table ${iml_schema}.agt_reg_debit_crdt_sign_h truncate partition for ('mpcsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_reg_debit_crdt_sign_h exchange subpartition p_mpcsf1_19000101 with table ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_cl;
alter table ${iml_schema}.agt_reg_debit_crdt_sign_h exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_reg_debit_crdt_sign_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_tm purge;
drop table ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_op purge;
drop table ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_reg_debit_crdt_sign_h_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_reg_debit_crdt_sign_h', partname => 'p_mpcsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
