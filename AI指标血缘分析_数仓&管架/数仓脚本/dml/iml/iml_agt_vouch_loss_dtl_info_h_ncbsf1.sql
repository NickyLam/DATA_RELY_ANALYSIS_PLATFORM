/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_vouch_loss_dtl_info_h_ncbsf1
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
alter table ${iml_schema}.agt_vouch_loss_dtl_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_vouch_loss_dtl_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loss_idf -- 挂失标识符
    ,loss_id -- 挂失编号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,loss_begin_dt -- 挂失起始日期
    ,reissue_begin_dt -- 补发起始日期
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_begin_num -- 凭证起始号码
    ,vouch_termnt_num -- 凭证终止号码
    ,new_vouch_type_cd -- 新凭证类型代码
    ,new_vouch_no -- 新凭证号码
    ,vouch_loss_status_cd -- 凭证挂失状态代码
    ,chn_id -- 渠道编号
    ,tran_tm -- 交易时间
    ,public_agent_name -- 代办人名称
    ,public_agent_nation -- 代办人国籍
    ,public_agent_cert_type_cd -- 代办人证件类型代码
    ,public_agent_cert_no -- 代办人证件号码
    ,public_agent_tel_num -- 代办人电话号码
    ,unloss_public_agent_name -- 解挂代办人姓名
    ,unloss_public_agent_nation -- 解挂代办人国籍
    ,unloss_public_agent_cert_type_cd -- 解挂代办人证件类型代码
    ,unloss_public_agent_cert_no -- 解挂代办人证件号码
    ,unloss_public_agent_phone -- 解挂代办人联系电话
    ,operr_cert_no -- 经办人证件号码
    ,operr_cert_type_cd -- 经办人证件类型代码
    ,operr_name -- 经办人姓名
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_vouch_loss_dtl_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_vouch_loss_dtl_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_vouch_loss_dtl_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_voucher_lost_detail-1
insert into ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loss_idf -- 挂失标识符
    ,loss_id -- 挂失编号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,loss_begin_dt -- 挂失起始日期
    ,reissue_begin_dt -- 补发起始日期
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_begin_num -- 凭证起始号码
    ,vouch_termnt_num -- 凭证终止号码
    ,new_vouch_type_cd -- 新凭证类型代码
    ,new_vouch_no -- 新凭证号码
    ,vouch_loss_status_cd -- 凭证挂失状态代码
    ,chn_id -- 渠道编号
    ,tran_tm -- 交易时间
    ,public_agent_name -- 代办人名称
    ,public_agent_nation -- 代办人国籍
    ,public_agent_cert_type_cd -- 代办人证件类型代码
    ,public_agent_cert_no -- 代办人证件号码
    ,public_agent_tel_num -- 代办人电话号码
    ,unloss_public_agent_name -- 解挂代办人姓名
    ,unloss_public_agent_nation -- 解挂代办人国籍
    ,unloss_public_agent_cert_type_cd -- 解挂代办人证件类型代码
    ,unloss_public_agent_cert_no -- 解挂代办人证件号码
    ,unloss_public_agent_phone -- 解挂代办人联系电话
    ,operr_cert_no -- 经办人证件号码
    ,operr_cert_type_cd -- 经办人证件类型代码
    ,operr_name -- 经办人姓名
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101046'||P1.LOST_KEY||P1.LOST_NO||P1.SEQ_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.LOST_KEY -- 挂失标识符
    ,P1.LOST_NO -- 挂失编号
    ,P1.SEQ_NO -- 序号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.STOP_START_DATE -- 挂失起始日期
    ,P1.STOP_END_DATE -- 补发起始日期
    ,P1.DOC_TYPE -- 存款凭证类别代码
    ,P1.VOUCHER_START_NO -- 凭证起始号码
    ,P1.VOUCHER_END_NO -- 凭证终止号码
    ,nvl(trim(P1.NEW_DOC_TYPE),'-') -- 新凭证类型代码
    ,P1.NEW_VOUCHER_NO -- 新凭证号码
    ,P1.VOUCHER_LOST_STATUS -- 凭证挂失状态代码
    ,nvl(trim(P1.SOURCE_TYPE),'-') -- 渠道编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.COMMISSION_CLIENT_NAME -- 代办人名称
    ,P1.COMMISSION_COUNTRY -- 代办人国籍
    ,P1.COMMISSION_DOCUMENT_TYPE -- 代办人证件类型代码
    ,P1.COMMISSION_DOCUMENT_ID -- 代办人证件号码
    ,P1.COMMISSION_CLIENT_TEL -- 代办人电话号码
    ,P1.UNLOST_COMM_NAME1 -- 解挂代办人姓名
    ,P1.UNLOST_COUNTRY -- 解挂代办人国籍
    ,P1.UNLOST_DOCUMENT_TYPE1 -- 解挂代办人证件类型代码
    ,P1.UNLOST_DOCUMENT_ID1 -- 解挂代办人证件号码
    ,P1.UNLOST_PHONE -- 解挂代办人联系电话
    ,P1.OFF_DOCUMENT_ID -- 经办人证件号码
    ,nvl(trim(P1.OFF_DOCUMENT_TYPE),'0000') -- 经办人证件类型代码
    ,P1.OPERATOR_NAME -- 经办人姓名
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_voucher_lost_detail' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_voucher_lost_detail p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,loss_idf
  	                                        ,loss_id
  	                                        ,seq_num
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
        into ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loss_idf -- 挂失标识符
    ,loss_id -- 挂失编号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,loss_begin_dt -- 挂失起始日期
    ,reissue_begin_dt -- 补发起始日期
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_begin_num -- 凭证起始号码
    ,vouch_termnt_num -- 凭证终止号码
    ,new_vouch_type_cd -- 新凭证类型代码
    ,new_vouch_no -- 新凭证号码
    ,vouch_loss_status_cd -- 凭证挂失状态代码
    ,chn_id -- 渠道编号
    ,tran_tm -- 交易时间
    ,public_agent_name -- 代办人名称
    ,public_agent_nation -- 代办人国籍
    ,public_agent_cert_type_cd -- 代办人证件类型代码
    ,public_agent_cert_no -- 代办人证件号码
    ,public_agent_tel_num -- 代办人电话号码
    ,unloss_public_agent_name -- 解挂代办人姓名
    ,unloss_public_agent_nation -- 解挂代办人国籍
    ,unloss_public_agent_cert_type_cd -- 解挂代办人证件类型代码
    ,unloss_public_agent_cert_no -- 解挂代办人证件号码
    ,unloss_public_agent_phone -- 解挂代办人联系电话
    ,operr_cert_no -- 经办人证件号码
    ,operr_cert_type_cd -- 经办人证件类型代码
    ,operr_name -- 经办人姓名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loss_idf -- 挂失标识符
    ,loss_id -- 挂失编号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,loss_begin_dt -- 挂失起始日期
    ,reissue_begin_dt -- 补发起始日期
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_begin_num -- 凭证起始号码
    ,vouch_termnt_num -- 凭证终止号码
    ,new_vouch_type_cd -- 新凭证类型代码
    ,new_vouch_no -- 新凭证号码
    ,vouch_loss_status_cd -- 凭证挂失状态代码
    ,chn_id -- 渠道编号
    ,tran_tm -- 交易时间
    ,public_agent_name -- 代办人名称
    ,public_agent_nation -- 代办人国籍
    ,public_agent_cert_type_cd -- 代办人证件类型代码
    ,public_agent_cert_no -- 代办人证件号码
    ,public_agent_tel_num -- 代办人电话号码
    ,unloss_public_agent_name -- 解挂代办人姓名
    ,unloss_public_agent_nation -- 解挂代办人国籍
    ,unloss_public_agent_cert_type_cd -- 解挂代办人证件类型代码
    ,unloss_public_agent_cert_no -- 解挂代办人证件号码
    ,unloss_public_agent_phone -- 解挂代办人联系电话
    ,operr_cert_no -- 经办人证件号码
    ,operr_cert_type_cd -- 经办人证件类型代码
    ,operr_name -- 经办人姓名
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
    ,nvl(n.loss_idf, o.loss_idf) as loss_idf -- 挂失标识符
    ,nvl(n.loss_id, o.loss_id) as loss_id -- 挂失编号
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.loss_begin_dt, o.loss_begin_dt) as loss_begin_dt -- 挂失起始日期
    ,nvl(n.reissue_begin_dt, o.reissue_begin_dt) as reissue_begin_dt -- 补发起始日期
    ,nvl(n.dep_vouch_cate_cd, o.dep_vouch_cate_cd) as dep_vouch_cate_cd -- 存款凭证类别代码
    ,nvl(n.vouch_begin_num, o.vouch_begin_num) as vouch_begin_num -- 凭证起始号码
    ,nvl(n.vouch_termnt_num, o.vouch_termnt_num) as vouch_termnt_num -- 凭证终止号码
    ,nvl(n.new_vouch_type_cd, o.new_vouch_type_cd) as new_vouch_type_cd -- 新凭证类型代码
    ,nvl(n.new_vouch_no, o.new_vouch_no) as new_vouch_no -- 新凭证号码
    ,nvl(n.vouch_loss_status_cd, o.vouch_loss_status_cd) as vouch_loss_status_cd -- 凭证挂失状态代码
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.public_agent_name, o.public_agent_name) as public_agent_name -- 代办人名称
    ,nvl(n.public_agent_nation, o.public_agent_nation) as public_agent_nation -- 代办人国籍
    ,nvl(n.public_agent_cert_type_cd, o.public_agent_cert_type_cd) as public_agent_cert_type_cd -- 代办人证件类型代码
    ,nvl(n.public_agent_cert_no, o.public_agent_cert_no) as public_agent_cert_no -- 代办人证件号码
    ,nvl(n.public_agent_tel_num, o.public_agent_tel_num) as public_agent_tel_num -- 代办人电话号码
    ,nvl(n.unloss_public_agent_name, o.unloss_public_agent_name) as unloss_public_agent_name -- 解挂代办人姓名
    ,nvl(n.unloss_public_agent_nation, o.unloss_public_agent_nation) as unloss_public_agent_nation -- 解挂代办人国籍
    ,nvl(n.unloss_public_agent_cert_type_cd, o.unloss_public_agent_cert_type_cd) as unloss_public_agent_cert_type_cd -- 解挂代办人证件类型代码
    ,nvl(n.unloss_public_agent_cert_no, o.unloss_public_agent_cert_no) as unloss_public_agent_cert_no -- 解挂代办人证件号码
    ,nvl(n.unloss_public_agent_phone, o.unloss_public_agent_phone) as unloss_public_agent_phone -- 解挂代办人联系电话
    ,nvl(n.operr_cert_no, o.operr_cert_no) as operr_cert_no -- 经办人证件号码
    ,nvl(n.operr_cert_type_cd, o.operr_cert_type_cd) as operr_cert_type_cd -- 经办人证件类型代码
    ,nvl(n.operr_name, o.operr_name) as operr_name -- 经办人姓名
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.loss_idf is null
            and n.loss_id is null
            and n.seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.loss_idf is null
            and n.loss_id is null
            and n.seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.loss_idf is null
            and n.loss_id is null
            and n.seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.loss_idf = n.loss_idf
            and o.loss_id = n.loss_id
            and o.seq_num = n.seq_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.loss_idf is null
        and o.loss_id is null
        and o.seq_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.loss_idf is null
        and n.loss_id is null
        and n.seq_num is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.loss_begin_dt <> n.loss_begin_dt
        or o.reissue_begin_dt <> n.reissue_begin_dt
        or o.dep_vouch_cate_cd <> n.dep_vouch_cate_cd
        or o.vouch_begin_num <> n.vouch_begin_num
        or o.vouch_termnt_num <> n.vouch_termnt_num
        or o.new_vouch_type_cd <> n.new_vouch_type_cd
        or o.new_vouch_no <> n.new_vouch_no
        or o.vouch_loss_status_cd <> n.vouch_loss_status_cd
        or o.chn_id <> n.chn_id
        or o.tran_tm <> n.tran_tm
        or o.public_agent_name <> n.public_agent_name
        or o.public_agent_nation <> n.public_agent_nation
        or o.public_agent_cert_type_cd <> n.public_agent_cert_type_cd
        or o.public_agent_cert_no <> n.public_agent_cert_no
        or o.public_agent_tel_num <> n.public_agent_tel_num
        or o.unloss_public_agent_name <> n.unloss_public_agent_name
        or o.unloss_public_agent_nation <> n.unloss_public_agent_nation
        or o.unloss_public_agent_cert_type_cd <> n.unloss_public_agent_cert_type_cd
        or o.unloss_public_agent_cert_no <> n.unloss_public_agent_cert_no
        or o.unloss_public_agent_phone <> n.unloss_public_agent_phone
        or o.operr_cert_no <> n.operr_cert_no
        or o.operr_cert_type_cd <> n.operr_cert_type_cd
        or o.operr_name <> n.operr_name
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loss_idf -- 挂失标识符
    ,loss_id -- 挂失编号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,loss_begin_dt -- 挂失起始日期
    ,reissue_begin_dt -- 补发起始日期
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_begin_num -- 凭证起始号码
    ,vouch_termnt_num -- 凭证终止号码
    ,new_vouch_type_cd -- 新凭证类型代码
    ,new_vouch_no -- 新凭证号码
    ,vouch_loss_status_cd -- 凭证挂失状态代码
    ,chn_id -- 渠道编号
    ,tran_tm -- 交易时间
    ,public_agent_name -- 代办人名称
    ,public_agent_nation -- 代办人国籍
    ,public_agent_cert_type_cd -- 代办人证件类型代码
    ,public_agent_cert_no -- 代办人证件号码
    ,public_agent_tel_num -- 代办人电话号码
    ,unloss_public_agent_name -- 解挂代办人姓名
    ,unloss_public_agent_nation -- 解挂代办人国籍
    ,unloss_public_agent_cert_type_cd -- 解挂代办人证件类型代码
    ,unloss_public_agent_cert_no -- 解挂代办人证件号码
    ,unloss_public_agent_phone -- 解挂代办人联系电话
    ,operr_cert_no -- 经办人证件号码
    ,operr_cert_type_cd -- 经办人证件类型代码
    ,operr_name -- 经办人姓名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loss_idf -- 挂失标识符
    ,loss_id -- 挂失编号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,loss_begin_dt -- 挂失起始日期
    ,reissue_begin_dt -- 补发起始日期
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_begin_num -- 凭证起始号码
    ,vouch_termnt_num -- 凭证终止号码
    ,new_vouch_type_cd -- 新凭证类型代码
    ,new_vouch_no -- 新凭证号码
    ,vouch_loss_status_cd -- 凭证挂失状态代码
    ,chn_id -- 渠道编号
    ,tran_tm -- 交易时间
    ,public_agent_name -- 代办人名称
    ,public_agent_nation -- 代办人国籍
    ,public_agent_cert_type_cd -- 代办人证件类型代码
    ,public_agent_cert_no -- 代办人证件号码
    ,public_agent_tel_num -- 代办人电话号码
    ,unloss_public_agent_name -- 解挂代办人姓名
    ,unloss_public_agent_nation -- 解挂代办人国籍
    ,unloss_public_agent_cert_type_cd -- 解挂代办人证件类型代码
    ,unloss_public_agent_cert_no -- 解挂代办人证件号码
    ,unloss_public_agent_phone -- 解挂代办人联系电话
    ,operr_cert_no -- 经办人证件号码
    ,operr_cert_type_cd -- 经办人证件类型代码
    ,operr_name -- 经办人姓名
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
    ,o.loss_idf -- 挂失标识符
    ,o.loss_id -- 挂失编号
    ,o.seq_num -- 序号
    ,o.cust_id -- 客户编号
    ,o.loss_begin_dt -- 挂失起始日期
    ,o.reissue_begin_dt -- 补发起始日期
    ,o.dep_vouch_cate_cd -- 存款凭证类别代码
    ,o.vouch_begin_num -- 凭证起始号码
    ,o.vouch_termnt_num -- 凭证终止号码
    ,o.new_vouch_type_cd -- 新凭证类型代码
    ,o.new_vouch_no -- 新凭证号码
    ,o.vouch_loss_status_cd -- 凭证挂失状态代码
    ,o.chn_id -- 渠道编号
    ,o.tran_tm -- 交易时间
    ,o.public_agent_name -- 代办人名称
    ,o.public_agent_nation -- 代办人国籍
    ,o.public_agent_cert_type_cd -- 代办人证件类型代码
    ,o.public_agent_cert_no -- 代办人证件号码
    ,o.public_agent_tel_num -- 代办人电话号码
    ,o.unloss_public_agent_name -- 解挂代办人姓名
    ,o.unloss_public_agent_nation -- 解挂代办人国籍
    ,o.unloss_public_agent_cert_type_cd -- 解挂代办人证件类型代码
    ,o.unloss_public_agent_cert_no -- 解挂代办人证件号码
    ,o.unloss_public_agent_phone -- 解挂代办人联系电话
    ,o.operr_cert_no -- 经办人证件号码
    ,o.operr_cert_type_cd -- 经办人证件类型代码
    ,o.operr_name -- 经办人姓名
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
from ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.loss_idf = n.loss_idf
            and o.loss_id = n.loss_id
            and o.seq_num = n.seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.loss_idf = d.loss_idf
            and o.loss_id = d.loss_id
            and o.seq_num = d.seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_vouch_loss_dtl_info_h;
--alter table ${iml_schema}.agt_vouch_loss_dtl_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_vouch_loss_dtl_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_vouch_loss_dtl_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_vouch_loss_dtl_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_vouch_loss_dtl_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_vouch_loss_dtl_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_vouch_loss_dtl_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_vouch_loss_dtl_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_vouch_loss_dtl_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
