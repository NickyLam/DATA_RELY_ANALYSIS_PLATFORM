/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_jd_cust_jdjrf1
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
drop table ${iml_schema}.pty_jd_cust_jdjrf1_tm purge;
drop table ${iml_schema}.pty_jd_cust_jdjrf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_jd_cust add partition p_jdjrf1 values ('jdjrf1')(
        subpartition p_jdjrf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_jd_cust modify partition p_jdjrf1
    add subpartition p_jdjrf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_jd_cust_jdjrf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_jd_cust partition for ('jdjrf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_jd_cust_jdjrf1_tm
compress ${option_switch} for query high
as
select
    cust_id -- 客户编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,party_id -- 当事人编号
    ,cust_name -- 客户名称
    ,gender_cd -- 性别代码
    ,birth_dt -- 出生日期
    ,resdnt_flg -- 居民标志
    ,cust_status_cd -- 客户状态代码
    ,dom_overs_flg_cd -- 境内境外标志代码
    ,cert_type_cd -- 证件类型代码
    ,cert_id -- 证件编号
    ,mobile_no -- 手机号码
    ,posta_addr -- 通讯地址
    ,bind_bank_card_name -- 绑定银行卡行名
    ,bind_bank_card_id -- 绑定银行卡编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_jd_cust
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_jd_cust_jdjrf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_jd_cust partition for ('jdjrf1') where 0=1;

-- 2.1 insert data to tm table
-- rcrs_jdjr_cus_indiv-
insert into ${iml_schema}.pty_jd_cust_jdjrf1_tm(
    cust_id -- 客户编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,party_id -- 当事人编号
    ,cust_name -- 客户名称
    ,gender_cd -- 性别代码
    ,birth_dt -- 出生日期
    ,resdnt_flg -- 居民标志
    ,cust_status_cd -- 客户状态代码
    ,dom_overs_flg_cd -- 境内境外标志代码
    ,cert_type_cd -- 证件类型代码
    ,cert_id -- 证件编号
    ,mobile_no -- 手机号码
    ,posta_addr -- 通讯地址
    ,bind_bank_card_name -- 绑定银行卡行名
    ,bind_bank_card_id -- 绑定银行卡编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CUS_NO -- 客户编号
    ,'9999' -- 法人编号
    ,'RCRS' -- 源系统代码
    ,NVL(TRIM(p2.CUS_ID),' ') -- 当事人编号
    ,P1.CUS_NAME -- 客户名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CUS_SEX END -- 性别代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.BIRTH_DT) -- 出生日期
    ,P1.LOCAL_FALG -- 居民标志
    ,P1.CUS_STATUS -- 客户状态代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.USE_AREA END -- 境内境外标志代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CERT_TYPE END -- 证件类型代码
    ,P1.CERT_NO -- 证件编号
    ,P1.TELEPHONE -- 手机号码
    ,P1.ADRESS -- 通讯地址
    ,P1.BANK_NAME -- 绑定银行卡行名
    ,P1.BAND_ACCOUNT_NO -- 绑定银行卡编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_jdjr_cus_indiv' -- 源表名称
    ,'jdjrf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_jdjr_cus_indiv p1
    left join (select a.*,row_number() over(partition by cus_no order by buss_date desc) seq from iol.rcrs_jdjr_acc_loan a where a.start_dt<= to_date('${batch_date}','yyyymmdd') 
and a.end_dt>to_date('${batch_date}','yyyymmdd')  )  p2 on p1.cus_no=p2.cus_no 
and p2.seq=1  
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CUS_SEX = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'RCRS'
        AND R1.SRC_TAB_EN_NAME= 'RCRS_JDJR_CUS_INDIV'
        AND R1.SRC_FIELD_EN_NAME= 'CUS_SEX'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_JD_CUST'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'GENDER_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.USE_AREA = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'RCRS'
        AND R2.SRC_TAB_EN_NAME= 'RCRS_JDJR_CUS_INDIV'
        AND R2.SRC_FIELD_EN_NAME= 'USE_AREA'
        AND R2.TARGET_TAB_EN_NAME= 'PTY_JD_CUST'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'DOM_OVERS_FLG_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CERT_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'RCRS'
        AND R3.SRC_TAB_EN_NAME= 'RCRS_JDJR_CUS_INDIV'
        AND R3.SRC_FIELD_EN_NAME= 'CERT_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'PTY_JD_CUST'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CERT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.pty_jd_cust_jdjrf1_ex(
    cust_id -- 客户编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,party_id -- 当事人编号
    ,cust_name -- 客户名称
    ,gender_cd -- 性别代码
    ,birth_dt -- 出生日期
    ,resdnt_flg -- 居民标志
    ,cust_status_cd -- 客户状态代码
    ,dom_overs_flg_cd -- 境内境外标志代码
    ,cert_type_cd -- 证件类型代码
    ,cert_id -- 证件编号
    ,mobile_no -- 手机号码
    ,posta_addr -- 通讯地址
    ,bind_bank_card_name -- 绑定银行卡行名
    ,bind_bank_card_id -- 绑定银行卡编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.sorc_sys_cd, o.sorc_sys_cd) as sorc_sys_cd -- 源系统代码
    ,nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别代码
    ,nvl(n.birth_dt, o.birth_dt) as birth_dt -- 出生日期
    ,nvl(n.resdnt_flg, o.resdnt_flg) as resdnt_flg -- 居民标志
    ,nvl(n.cust_status_cd, o.cust_status_cd) as cust_status_cd -- 客户状态代码
    ,nvl(n.dom_overs_flg_cd, o.dom_overs_flg_cd) as dom_overs_flg_cd -- 境内境外标志代码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_id, o.cert_id) as cert_id -- 证件编号
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.posta_addr, o.posta_addr) as posta_addr -- 通讯地址
    ,nvl(n.bind_bank_card_name, o.bind_bank_card_name) as bind_bank_card_name -- 绑定银行卡行名
    ,nvl(n.bind_bank_card_id, o.bind_bank_card_id) as bind_bank_card_id -- 绑定银行卡编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.cust_id is null
                and o.lp_id is null
                and o.sorc_sys_cd is null
            ) or (
                o.party_id <> n.party_id
                or o.cust_name <> n.cust_name
                or o.gender_cd <> n.gender_cd
                or o.birth_dt <> n.birth_dt
                or o.resdnt_flg <> n.resdnt_flg
                or o.cust_status_cd <> n.cust_status_cd
                or o.dom_overs_flg_cd <> n.dom_overs_flg_cd
                or o.cert_type_cd <> n.cert_type_cd
                or o.cert_id <> n.cert_id
                or o.mobile_no <> n.mobile_no
                or o.posta_addr <> n.posta_addr
                or o.bind_bank_card_name <> n.bind_bank_card_name
                or o.bind_bank_card_id <> n.bind_bank_card_id
            )
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.cust_id is null
                and n.lp_id is null
                and n.sorc_sys_cd is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_jd_cust_jdjrf1_tm n
    full join ${iml_schema}.pty_jd_cust_jdjrf1_bk o
        on
            o.cust_id = n.cust_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_jd_cust truncate partition for ('jdjrf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_jd_cust exchange subpartition p_jdjrf1_${batch_date} with table ${iml_schema}.pty_jd_cust_jdjrf1_ex;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_jd_cust to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_jd_cust_jdjrf1_tm purge;
drop table ${iml_schema}.pty_jd_cust_jdjrf1_ex purge;
drop table ${iml_schema}.pty_jd_cust_jdjrf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_jd_cust', partname => 'p_jdjrf1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);