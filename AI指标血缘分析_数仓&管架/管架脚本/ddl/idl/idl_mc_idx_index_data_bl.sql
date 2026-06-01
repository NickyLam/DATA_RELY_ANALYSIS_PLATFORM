
/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_banking_q
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_idx_index_data_bl
whenever sqlerror continue none;
drop table ${idl_schema}.mc_idx_index_data_bl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_idx_index_data_bl(
     index_no          VARCHAR2(60),
     org_no            VARCHAR2(60),
     biz_strip_line_cd VARCHAR2(30),
     dim_cd1           VARCHAR2(30),
     dim_cd2           VARCHAR2(30),
     dim_cd3           VARCHAR2(30),
     batch_freq        VARCHAR2(30),
     index_measure     VARCHAR2(30),
     curr_cd           VARCHAR2(30),
     index_val         NUMBER(30,8),
     etl_dt            DATE,
     etl_timestamp     TIMESTAMP(6)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200016', '000000', null, null, null, null, 'M', '001', 'BWB', 1019391600, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200001', '000000', null, null, null, null, 'M', '001', 'BWB', .743998, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200093', '000000', null, null, null, null, 'M', '001', 'BWB', 2.649855, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200003', '000000', null, null, null, null, 'M', '001', 'BWB', 356.1644, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100005', '000000', null, null, null, null, 'M', '001', 'BWB', 23368632100, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100006', '000000', null, null, null, null, 'M', '001', 'BWB', 16236683300, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100007', '000000', null, null, null, null, 'M', '001', 'BWB', 16236683300, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100001', '000000', null, null, null, null, 'M', '001', 'BWB', 12.74104, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100002', '000000', null, null, null, null, 'M', '001', 'BWB', 8.852564, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100003', '000000', null, null, null, null, 'M', '001', 'BWB', 8.852564, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100004', '000000', null, null, null, null, 'M', '001', 'BWB', 4.738781, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100011', '000000', null, null, null, null, 'M', '001', 'BWB', 17015000000, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100149', '000000', null, null, null, null, 'M', '001', 'BWB', 15305000000, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200014', '000000', null, null, null, null, 'M', '001', 'BWB', 139701420000, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200015', '000000', null, null, null, null, 'M', '001', 'BWB', 902917500, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200017', '000000', null, null, null, null, 'M', '001', 'BWB', 273589700, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200018', '000000', null, null, null, null, 'M', '001', 'BWB', 525058300, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200019', '000000', null, null, null, null, 'M', '001', 'BWB', 275162300, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200016', '000000', null, null, null, null, 'M', '001', 'BWB', 1073810300, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200001', '000000', null, null, null, null, 'M', '001', 'BWB', .757922, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200093', '000000', null, null, null, null, 'M', '001', 'BWB', 2.669999, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200003', '000000', null, null, null, null, 'M', '001', 'BWB', 352.2787, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100005', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100006', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100007', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100001', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100002', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100003', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100004', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100011', '000000', null, null, null, null, 'M', '001', 'BWB', 17181000000, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100149', '000000', null, null, null, null, 'M', '001', 'BWB', 16729000000, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200014', '000000', null, null, null, null, 'M', '001', 'BWB', 145556140000, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200015', '000000', null, null, null, null, 'M', '001', 'BWB', 789624200, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200017', '000000', null, null, null, null, 'M', '001', 'BWB', 302652800, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200018', '000000', null, null, null, null, 'M', '001', 'BWB', 538483400, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200019', '000000', null, null, null, null, 'M', '001', 'BWB', 327503400, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200016', '000000', null, null, null, null, 'M', '001', 'BWB', 1168639600, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200001', '000000', null, null, null, null, 'M', '001', 'BWB', .792221, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200093', '000000', null, null, null, null, 'M', '001', 'BWB', 2.6713, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200003', '000000', null, null, null, null, 'M', '001', 'BWB', 337.1914, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100005', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100006', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100007', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100001', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100002', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100003', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100004', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100011', '000000', null, null, null, null, 'M', '001', 'BWB', 16753000000, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100149', '000000', null, null, null, null, 'M', '001', 'BWB', 18617000000, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200014', '000000', null, null, null, null, 'M', '001', 'BWB', 146074840000, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200015', '000000', null, null, null, null, 'M', '001', 'BWB', 782041400, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200017', '000000', null, null, null, null, 'M', '001', 'BWB', 291260000, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200018', '000000', null, null, null, null, 'M', '001', 'BWB', 535196500, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200019', '000000', null, null, null, null, 'M', '001', 'BWB', 379303500, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200016', '000000', null, null, null, null, 'M', '001', 'BWB', 1205760000, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200001', '000000', null, null, null, null, 'M', '001', 'BWB', .814358, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200093', '000000', null, null, null, null, 'M', '001', 'BWB', 2.670079, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200003', '000000', null, null, null, null, 'M', '001', 'BWB', 327.8753, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100005', '000000', null, null, null, null, 'M', '001', 'BWB', 23647959200, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100006', '000000', null, null, null, null, 'M', '001', 'BWB', 16447907900, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100007', '000000', null, null, null, null, 'M', '001', 'BWB', 16447907900, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100001', '000000', null, null, null, null, 'M', '001', 'BWB', 12.52681, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100002', '000000', null, null, null, null, 'M', '001', 'BWB', 8.712794, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100003', '000000', null, null, null, null, 'M', '001', 'BWB', 8.712794, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100004', '000000', null, null, null, null, 'M', '001', 'BWB', 4.341781, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100011', '000000', null, null, null, null, 'M', '001', 'BWB', 16093000000, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100149', '000000', null, null, null, null, 'M', '001', 'BWB', 21056000000, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200014', '000000', null, null, null, null, 'M', '001', 'BWB', 149917400000, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200015', '000000', null, null, null, null, 'M', '001', 'BWB', 747376000, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200017', '000000', null, null, null, null, 'M', '001', 'BWB', 267235200, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200018', '000000', null, null, null, null, 'M', '001', 'BWB', 582427200, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200019', '000000', null, null, null, null, 'M', '001', 'BWB', 451696900, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200016', '000000', null, null, null, null, 'M', '001', 'BWB', 1301359200, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200001', '000000', null, null, null, null, 'M', '001', 'BWB', .856348, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200093', '000000', null, null, null, null, 'M', '001', 'BWB', 2.600143, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200003', '000000', null, null, null, null, 'M', '001', 'BWB', 303.6315, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100005', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100006', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100007', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100001', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100002', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100003', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100004', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100011', '000000', null, null, null, null, 'M', '001', 'BWB', 15267000000, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100149', '000000', null, null, null, null, 'M', '001', 'BWB', 20272000000, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '001', 'BWB', 68754132120, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '001', 'BWB', 68738645960, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '001', 'BWB', 68685900330, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '002', 'BWB', 68586456840, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '001', 'BWB', 68426765650, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '001', 'BWB', 68134048500, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '001', 'BWB', 67884147740, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '002', 'BWB', 67595737590, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '002', 'BWB', 67502228170, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '001', 'BWB', 67254815130, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '002', 'BWB', 67210392940, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '001', 'BWB', 66641260280, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '001', 'BWB', 66619829920, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '002', 'BWB', 66617997810, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '002', 'BWB', 66399441560, to_date('31-07-2019', 'dd-mm-yyyy'), null);
commit;
prompt 100 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '002', 'BWB', 66346473760, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '001', 'BWB', 66146254740, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '002', 'BWB', 66128912450, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '001', 'BWB', 65935084600, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '001', 'BWB', 65849098560, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '002', 'BWB', 65557149090, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '001', 'BWB', 65126715990, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '001', 'BWB', 64852813410, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '002', 'BWB', 64826398420, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '002', 'BWB', 64764371730, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '001', 'BWB', 64616414500, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '002', 'BWB', 64546542410, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '001', 'BWB', 63821247420, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '002', 'BWB', 63616554090, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '002', 'BWB', 63210193780, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '001', 'BWB', 63099482400, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '001', 'BWB', 62855568160, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '002', 'BWB', 62716703790, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '002', 'BWB', 62039158920, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '002', 'BWB', 61944227160, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '002', 'BWB', 61610968900, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '002', 'BWB', 60745369790, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '001', 'BWB', 60077561740, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '001', 'BWB', 59797294620, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '002', 'BWB', 59586784790, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '002', 'BWB', 59189798170, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '001', 'BWB', 58538297100, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '001', 'BWB', 56327881570, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '002', 'BWB', 56295636130, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '001', 'BWB', 53340447680, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '001', 'BWB', 53015389380, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '001', 'BWB', 51699959430, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '001', 'BWB', 50765361980, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '002', 'BWB', 50732736240, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '002', 'BWB', 50319049190, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '002', 'BWB', 49680478030, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '001', 'BWB', 49174520190, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '001', 'BWB', 49132357600, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '002', 'BWB', 48696857490, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '002', 'BWB', 48318388440, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '002', 'BWB', 48060095470, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '001', 'BWB', 47802173190, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '002', 'BWB', 47550523430, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '001', 'BWB', 47334357240, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '001', 'BWB', 47023045780, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '002', 'BWB', 46940496650, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '002', 'BWB', 46934591440, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '001', 'BWB', 46793564420, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '001', 'BWB', 46757964210, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '002', 'BWB', 46045211440, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '002', 'BWB', 46014133200, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '001', 'BWB', 45782978280, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '002', 'BWB', 45612929040, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '001', 'BWB', 45390394820, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '001', 'BWB', 45327651430, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '002', 'BWB', 44890317330, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '002', 'BWB', 44778129620, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '001', 'BWB', 44191442780, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '001', 'BWB', 44149222470, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '002', 'BWB', 44038690630, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '001', 'BWB', 44034891580, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '001', 'BWB', 43802904680, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '002', 'BWB', 43717710210, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '002', 'BWB', 43556669170, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '002', 'BWB', 43370240740, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '002', 'BWB', 43343210650, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '002', 'BWB', 43113683850, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '001', 'BWB', 42750758790, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '002', 'BWB', 42675343630, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '001', 'BWB', 42487604830, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '002', 'BWB', 42023314150, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '002', 'BWB', 41653572530, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '001', 'BWB', 41638997880, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '001', 'BWB', 41438434960, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '002', 'BWB', 41388485110, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '001', 'BWB', 41341379410, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '002', 'BWB', 41173320750, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '002', 'BWB', 41066306670, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '001', 'BWB', 40983022130, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '001', 'BWB', 40950238980, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '002', 'BWB', 40259540390, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '001', 'BWB', 39820165570, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '805', null, null, null, null, 'M', '002', 'BWB', 39718811900, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '001', 'BWB', 39491828200, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '002', 'BWB', 39145936990, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '001', 'BWB', 39020871860, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '002', 'BWB', 38465520910, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '001', 'BWB', 38438777470, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '002', 'BWB', 38418477500, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '001', 'BWB', 37723854900, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '002', 'BWB', 37683715240, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '001', 'BWB', 37618012650, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '001', 'BWB', 37454761900, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '001', 'BWB', 37416421870, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '001', 'BWB', 37380081640, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '002', 'BWB', 37336655340, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '001', 'BWB', 37287688650, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '001', 'BWB', 37064757910, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '001', 'BWB', 36969897640, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '001', 'BWB', 36967210790, to_date('30-11-2019', 'dd-mm-yyyy'), null);
commit;
prompt 200 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '002', 'BWB', 36956939720, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '001', 'BWB', 36902428650, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '002', 'BWB', 36809335090, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '002', 'BWB', 36530977220, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '001', 'BWB', 36513585200, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '001', 'BWB', 36365977650, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '002', 'BWB', 36240878840, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '002', 'BWB', 35997461640, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '001', 'BWB', 35991058650, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '001', 'BWB', 35986630030, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '002', 'BWB', 35929621600, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '002', 'BWB', 35862746070, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '002', 'BWB', 35844644480, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '002', 'BWB', 35560916390, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '002', 'BWB', 35434026530, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '801', null, null, null, null, 'M', '002', 'BWB', 35308549280, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '001', 'BWB', 35283435720, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '001', 'BWB', 35146072740, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '001', 'BWB', 34949758720, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '001', 'BWB', 34652800110, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '002', 'BWB', 34527026480, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '001', 'BWB', 34146671870, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '001', 'BWB', 34089767070, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '002', 'BWB', 33889801340, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '001', 'BWB', 33537259290, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '002', 'BWB', 33464830080, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '002', 'BWB', 33446813690, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '002', 'BWB', 33023944170, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '001', 'BWB', 32974457650, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '801', null, null, null, null, 'M', '002', 'BWB', 32951168960, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '001', 'BWB', 32603901650, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '001', 'BWB', 32305056410, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '002', 'BWB', 32284331630, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '002', 'BWB', 31738322910, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '001', 'BWB', 31518170090, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '002', 'BWB', 31371965420, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '002', 'BWB', 30902741600, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '001', 'BWB', 30702910750, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '002', 'BWB', 30679415720, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '001', 'BWB', 30475816050, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '002', 'BWB', 30105594920, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '001', 'BWB', 29954693050, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '001', 'BWB', 29944025950, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '001', 'BWB', 29353571630, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '002', 'BWB', 29281342460, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '001', 'BWB', 29165068020, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '002', 'BWB', 29007046890, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '002', 'BWB', 28896776820, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '002', 'BWB', 28683796330, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '001', 'BWB', 27950384750, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '002', 'BWB', 27817832750, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '002', 'BWB', 27649277390, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '001', 'BWB', 27534805210, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '001', 'BWB', 27212000210, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '001', 'BWB', 27183525450, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '001', 'BWB', 27103104090, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '002', 'BWB', 26898144850, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '001', 'BWB', 26808524450, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '002', 'BWB', 26578383740, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '002', 'BWB', 26561801000, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '002', 'BWB', 26373812770, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '001', 'BWB', 26352871450, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '001', 'BWB', 26336758320, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '001', 'BWB', 26156922230, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '002', 'BWB', 26049947630, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '001', 'BWB', 26037445030, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '002', 'BWB', 26033811910, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '002', 'BWB', 26024643770, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '001', 'BWB', 25989744450, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '001', 'BWB', 25934395440, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '001', 'BWB', 25852065520, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '001', 'BWB', 25846382740, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '001', 'BWB', 25766917320, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '001', 'BWB', 25725047030, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '001', 'BWB', 25719400750, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '002', 'BWB', 25696983450, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '002', 'BWB', 25601791530, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '001', 'BWB', 25566796890, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '002', 'BWB', 25480055680, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '002', 'BWB', 25268126890, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '002', 'BWB', 25260885300, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '001', 'BWB', 25241425890, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '002', 'BWB', 25185375600, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '002', 'BWB', 25108380730, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '002', 'BWB', 25050922300, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '002', 'BWB', 24897228250, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '001', 'BWB', 24891434980, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '001', 'BWB', 24871058740, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '002', 'BWB', 24795051060, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '002', 'BWB', 24659591150, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '001', 'BWB', 24412490530, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '002', 'BWB', 24170935240, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '002', 'BWB', 24100916730, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '002', 'BWB', 24097401660, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '002', 'BWB', 24078686500, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '002', 'BWB', 24044868790, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '001', 'BWB', 23879050120, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '002', 'BWB', 23817451650, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '002', 'BWB', 23799629240, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '002', 'BWB', 23712134390, to_date('31-07-2019', 'dd-mm-yyyy'), null);
commit;
prompt 300 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '002', 'BWB', 23708083720, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '001', 'BWB', 23455307120, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '001', 'BWB', 23325933120, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '001', 'BWB', 23234473670, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '002', 'BWB', 23193673470, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '001', 'BWB', 23142613140, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '002', 'BWB', 23093098300, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '001', 'BWB', 23060696320, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '001', 'BWB', 22975470620, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '805', null, null, null, null, 'M', '001', 'BWB', 22957782670, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '001', 'BWB', 22874732670, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '001', 'BWB', 22865685440, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '002', 'BWB', 22848822440, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '001', 'BWB', 22827396980, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '002', 'BWB', 22799210180, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '002', 'BWB', 22736244000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '805', null, null, null, null, 'M', '001', 'BWB', 22608412670, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '002', 'BWB', 22605677920, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '001', 'BWB', 22297988440, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '002', 'BWB', 22040811610, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '002', 'BWB', 21762175670, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '001', 'BWB', 21732250060, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '001', 'BWB', 21639714970, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '001', 'BWB', 21621369070, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '002', 'BWB', 21525879660, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '001', 'BWB', 21456248890, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '002', 'BWB', 21420243580, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '002', 'BWB', 21354542050, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '001', 'BWB', 21325757350, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '001', 'BWB', 21265892510, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '002', 'BWB', 21254186660, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '001', 'BWB', 20997081960, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '002', 'BWB', 20845448540, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '002', 'BWB', 20845017150, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '001', 'BWB', 20823289350, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '001', 'BWB', 20789960570, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '001', 'BWB', 20720519180, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '002', 'BWB', 20703857090, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '001', 'BWB', 20664505510, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '001', 'BWB', 20590172970, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '001', 'BWB', 20564057070, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '002', 'BWB', 20560778670, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '001', 'BWB', 20541552390, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '001', 'BWB', 20456806090, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '001', 'BWB', 20456592690, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '001', 'BWB', 20373105370, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '001', 'BWB', 20370547890, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '002', 'BWB', 20362112920, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '002', 'BWB', 20147074210, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '002', 'BWB', 20102094820, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '002', 'BWB', 20011399530, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '002', 'BWB', 20005575820, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '002', 'BWB', 19974847510, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '001', 'BWB', 19792976130, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '002', 'BWB', 19669748900, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '001', 'BWB', 19665347800, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '002', 'BWB', 19632878900, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '002', 'BWB', 19562981410, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '002', 'BWB', 19555683290, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '002', 'BWB', 19528432200, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '001', 'BWB', 19513355570, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '002', 'BWB', 19459267510, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '001', 'BWB', 19381327900, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '001', 'BWB', 19253131170, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '001', 'BWB', 19236390820, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '002', 'BWB', 19170685860, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '001', 'BWB', 19158230400, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '001', 'BWB', 19140446520, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '001', 'BWB', 19137837270, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '001', 'BWB', 19115319350, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '002', 'BWB', 19067309070, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '002', 'BWB', 19025495060, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '002', 'BWB', 19018578410, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '002', 'BWB', 19012767120, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '002', 'BWB', 18857891970, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '001', 'BWB', 18825705510, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '002', 'BWB', 18824942090, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '002', 'BWB', 18782807180, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '001', 'BWB', 18732966740, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '001', 'BWB', 18701867630, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '001', 'BWB', 18590716360, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '002', 'BWB', 11916561600, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '001', 'BWB', 11910080800, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '002', 'BWB', 11827190010, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '002', 'BWB', 11819224230, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '002', 'BWB', 11809914480, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '001', 'BWB', 11771860130, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '001', 'BWB', 11652730920, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '002', 'BWB', 11621249610, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '001', 'BWB', 11422784740, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '002', 'BWB', 11340892640, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '001', 'BWB', 11329980760, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '002', 'BWB', 11288111340, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '001', 'BWB', 11285923820, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '001', 'BWB', 11192022790, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '002', 'BWB', 11179654400, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '001', 'BWB', 6705098690, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '001', 'BWB', 11117836910, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '002', 'BWB', 11095336390, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '001', 'BWB', 10977969980, to_date('30-06-2020', 'dd-mm-yyyy'), null);
commit;
prompt 400 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '002', 'BWB', 10897052010, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '002', 'BWB', 10896197390, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '001', 'BWB', 10862022020, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '002', 'BWB', 10826450130, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '002', 'BWB', 10808397060, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '002', 'BWB', 10762240110, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '001', 'BWB', 10756105900, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '002', 'BWB', 10743167670, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '002', 'BWB', 10703178250, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '002', 'BWB', 10680514060, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '001', 'BWB', 10652292900, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '001', 'BWB', 10637587640, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '001', 'BWB', 10621508900, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '002', 'BWB', 10602905210, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '001', 'BWB', 10595099440, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '002', 'BWB', 10584598470, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '002', 'BWB', 10583848560, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '001', 'BWB', 10562004450, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '001', 'BWB', 10545774700, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '001', 'BWB', 10535968900, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '001', 'BWB', 10522475370, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '001', 'BWB', 10447678230, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '001', 'BWB', 10432292720, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '001', 'BWB', 10415157700, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '002', 'BWB', 6387859300, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '002', 'BWB', 10395253270, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '001', 'BWB', 10387683860, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '001', 'BWB', 10382177380, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '001', 'BWB', 10260163130, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '002', 'BWB', 10219305770, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '002', 'BWB', 10197897500, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '001', 'BWB', 10197819570, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '001', 'BWB', 10191884130, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '001', 'BWB', 10174184590, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '002', 'BWB', 10171137990, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '002', 'BWB', 10156982290, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '002', 'BWB', 10150964070, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '002', 'BWB', 10145549660, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '001', 'BWB', 10139734570, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '001', 'BWB', 10139662290, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '002', 'BWB', 10128787630, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '001', 'BWB', 10123113570, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '001', 'BWB', 10118209330, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '002', 'BWB', 10105087090, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '001', 'BWB', 10104104260, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '001', 'BWB', 10076348290, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '001', 'BWB', 10069878060, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '001', 'BWB', 10061003550, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '001', 'BWB', 10055616780, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '002', 'BWB', 10038082470, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '002', 'BWB', 10013346400, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '002', 'BWB', 10013083350, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '002', 'BWB', 10001940090, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '002', 'BWB', 9995919495, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '001', 'BWB', 9990558306, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '001', 'BWB', 9984998232, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '002', 'BWB', 9982898162, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '001', 'BWB', 9967094005, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '002', 'BWB', 9965474376, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '002', 'BWB', 9949236626, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '002', 'BWB', 9936682769, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '002', 'BWB', 9925687942, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '002', 'BWB', 9909728335, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '001', 'BWB', 9908945815, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '001', 'BWB', 9894839428, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '001', 'BWB', 9892605087, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '002', 'BWB', 9890022539, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '002', 'BWB', 9832792412, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '001', 'BWB', 9818177372, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '001', 'BWB', 9800565737, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '002', 'BWB', 9787701004, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '002', 'BWB', 9776582612, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '002', 'BWB', 9770237889, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '002', 'BWB', 9767165618, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '001', 'BWB', 9767164171, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '001', 'BWB', 9766371471, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '002', 'BWB', 9762205095, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '002', 'BWB', 9760243833, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '002', 'BWB', 9757924883, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '002', 'BWB', 9753495309, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '002', 'BWB', 9751762617, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '001', 'BWB', 9743016053, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '002', 'BWB', 9738048432, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '001', 'BWB', 9682859298, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '001', 'BWB', 9667511291, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '001', 'BWB', 9659943330, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '002', 'BWB', 9658268813, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '001', 'BWB', 9638973764, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '001', 'BWB', 9632131674, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '001', 'BWB', 9615211989, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '001', 'BWB', 9614441995, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '001', 'BWB', 9592336799, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '001', 'BWB', 9547622700, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '001', 'BWB', 9545847364, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '001', 'BWB', 9545500470, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '002', 'BWB', 9543866562, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '002', 'BWB', 9507629300, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '002', 'BWB', 9498798197, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '002', 'BWB', 9492991836, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '001', 'BWB', 9489241470, to_date('30-06-2020', 'dd-mm-yyyy'), null);
commit;
prompt 500 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '001', 'BWB', 9481170062, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '002', 'BWB', 9405728326, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '002', 'BWB', 9400511371, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '001', 'BWB', 9394497700, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '001', 'BWB', 9369827887, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '002', 'BWB', 9360102648, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '002', 'BWB', 9344833965, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '001', 'BWB', 9335619277, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '001', 'BWB', 9316021455, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '002', 'BWB', 9265988667, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '002', 'BWB', 9261901771, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '001', 'BWB', 9259553112, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '001', 'BWB', 9209518682, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '001', 'BWB', 9191200320, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '002', 'BWB', 9187787696, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '002', 'BWB', 9179641173, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '001', 'BWB', 9176253148, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '002', 'BWB', 9134996341, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '001', 'BWB', 9133276675, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '002', 'BWB', 9130479337, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '002', 'BWB', 9104158367, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '001', 'BWB', 9099784054, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '001', 'BWB', 9083725700, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '002', 'BWB', 9079485905, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '001', 'BWB', 9058868177, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '001', 'BWB', 9032732675, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '002', 'BWB', 8992149674, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '002', 'BWB', 8988604954, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '002', 'BWB', 18575189680, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '002', 'BWB', 18528312880, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '001', 'BWB', 18526173630, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '002', 'BWB', 18506833840, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '001', 'BWB', 18503562770, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '002', 'BWB', 18479830310, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '002', 'BWB', 18443629990, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '001', 'BWB', 18442123780, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '002', 'BWB', 18386570780, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '001', 'BWB', 18356366350, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '001', 'BWB', 18351432250, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '001', 'BWB', 18267974260, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '001', 'BWB', 18235488020, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '001', 'BWB', 18154917840, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '002', 'BWB', 18151304790, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '002', 'BWB', 18146481610, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '001', 'BWB', 18090489260, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '001', 'BWB', 18087915510, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '805', null, null, null, null, 'M', '002', 'BWB', 18080222450, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '001', 'BWB', 18075506310, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '001', 'BWB', 18010022430, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '001', 'BWB', 18007551510, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '001', 'BWB', 17956521950, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '002', 'BWB', 17956254810, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '001', 'BWB', 17950915380, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '001', 'BWB', 17948767020, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '002', 'BWB', 17945488810, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '002', 'BWB', 17935943700, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '001', 'BWB', 17935290490, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '002', 'BWB', 17908700780, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '002', 'BWB', 17863154970, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '001', 'BWB', 17828367090, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '001', 'BWB', 17764112060, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '002', 'BWB', 17725427090, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '001', 'BWB', 17635197790, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '801', null, null, null, null, 'M', '002', 'BWB', 17583122180, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '002', 'BWB', 17540588250, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '002', 'BWB', 17473477630, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '001', 'BWB', 17463961620, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '001', 'BWB', 17453855210, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '001', 'BWB', 17441695510, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '001', 'BWB', 17403348770, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '002', 'BWB', 17383761310, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '001', 'BWB', 17305374580, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '001', 'BWB', 17298370250, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '001', 'BWB', 17222318300, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '002', 'BWB', 17211334250, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '002', 'BWB', 17172243740, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '002', 'BWB', 17039094460, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '001', 'BWB', 17019552700, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '002', 'BWB', 16982567900, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '805', null, null, null, null, 'M', '002', 'BWB', 16837938550, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '002', 'BWB', 16831043930, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '002', 'BWB', 16809865510, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '001', 'BWB', 16743323100, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '001', 'BWB', 16704033090, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '002', 'BWB', 16698556010, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '002', 'BWB', 16633786160, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '002', 'BWB', 16520722460, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '001', 'BWB', 16430460000, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '801', null, null, null, null, 'M', '002', 'BWB', 16430446500, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '002', 'BWB', 16422718890, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '002', 'BWB', 16415448120, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '002', 'BWB', 16307621010, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200014', '000000', null, null, null, null, 'M', '001', 'BWB', 101617000000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200015', '000000', null, null, null, null, 'M', '001', 'BWB', 485496500, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200017', '000000', null, null, null, null, 'M', '001', 'BWB', 143475400, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200018', '000000', null, null, null, null, 'M', '001', 'BWB', 741476600, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200019', '000000', null, null, null, null, 'M', '001', 'BWB', 119576600, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200016', '000000', null, null, null, null, 'M', '001', 'BWB', 1004528600, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200001', '000000', null, null, null, null, 'M', '001', 'BWB', .974258, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200093', '000000', null, null, null, null, 'M', '001', 'BWB', 2.699951, to_date('31-07-2019', 'dd-mm-yyyy'), null);
commit;
prompt 600 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200003', '000000', null, null, null, null, 'M', '001', 'BWB', 277.1289, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100005', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100006', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100007', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100001', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100002', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100003', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100004', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100011', '000000', null, null, null, null, 'M', '001', 'BWB', 17079000000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100149', '000000', null, null, null, null, 'M', '001', 'BWB', 11412000000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200014', '000000', null, null, null, null, 'M', '001', 'BWB', 102244140000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200015', '000000', null, null, null, null, 'M', '001', 'BWB', 616710900, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200017', '000000', null, null, null, null, 'M', '001', 'BWB', 148108300, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200018', '000000', null, null, null, null, 'M', '001', 'BWB', 744295900, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200019', '000000', null, null, null, null, 'M', '001', 'BWB', 127742700, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200016', '000000', null, null, null, null, 'M', '001', 'BWB', 1020146800, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200001', '000000', null, null, null, null, 'M', '001', 'BWB', .982034, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200093', '000000', null, null, null, null, 'M', '001', 'BWB', 2.719999, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200003', '000000', null, null, null, null, 'M', '001', 'BWB', 276.9761, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100005', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100006', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100007', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100001', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100002', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100003', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100004', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100011', '000000', null, null, null, null, 'M', '001', 'BWB', 16621000000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100149', '000000', null, null, null, null, 'M', '001', 'BWB', 12517000000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200014', '000000', null, null, null, null, 'M', '001', 'BWB', 105475920000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200015', '000000', null, null, null, null, 'M', '001', 'BWB', 537496200, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200017', '000000', null, null, null, null, 'M', '001', 'BWB', 136745600, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200018', '000000', null, null, null, null, 'M', '001', 'BWB', 552470900, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200019', '000000', null, null, null, null, 'M', '001', 'BWB', 127422300, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200016', '000000', null, null, null, null, 'M', '001', 'BWB', 816638800, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200001', '000000', null, null, null, null, 'M', '001', 'BWB', .764428, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200093', '000000', null, null, null, null, 'M', '001', 'BWB', 2.619581, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200003', '000000', null, null, null, null, 'M', '001', 'BWB', 342.6852, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100005', '000000', null, null, null, null, 'M', '001', 'BWB', 18354223000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100006', '000000', null, null, null, null, 'M', '001', 'BWB', 14689471000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100007', '000000', null, null, null, null, 'M', '001', 'BWB', 14689471000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100001', '000000', null, null, null, null, 'M', '001', 'BWB', 12.81229, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100002', '000000', null, null, null, null, 'M', '001', 'BWB', 10.25408, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100003', '000000', null, null, null, null, 'M', '001', 'BWB', 10.25408, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100004', '000000', null, null, null, null, 'M', '001', 'BWB', 5.549296, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100011', '000000', null, null, null, null, 'M', '001', 'BWB', 16478000000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100149', '000000', null, null, null, null, 'M', '001', 'BWB', 11546000000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200014', '000000', null, null, null, null, 'M', '001', 'BWB', 107773760000, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200015', '000000', null, null, null, null, 'M', '001', 'BWB', 589016200, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200017', '000000', null, null, null, null, 'M', '001', 'BWB', 148687200, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200018', '000000', null, null, null, null, 'M', '001', 'BWB', 555469200, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200019', '000000', null, null, null, null, 'M', '001', 'BWB', 159907800, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200016', '000000', null, null, null, null, 'M', '001', 'BWB', 864064300, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200001', '000000', null, null, null, null, 'M', '001', 'BWB', .790785, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200093', '000000', null, null, null, null, 'M', '001', 'BWB', 2.600105, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200003', '000000', null, null, null, null, 'M', '001', 'BWB', 328.8003, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100005', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100006', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100007', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100001', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100002', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100003', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100004', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100011', '000000', null, null, null, null, 'M', '001', 'BWB', 16153000000, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100149', '000000', null, null, null, null, 'M', '001', 'BWB', 12093000000, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200014', '000000', null, null, null, null, 'M', '001', 'BWB', 108748350000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200015', '000000', null, null, null, null, 'M', '001', 'BWB', 970156600, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200017', '000000', null, null, null, null, 'M', '001', 'BWB', 202522500, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200018', '000000', null, null, null, null, 'M', '001', 'BWB', 557217000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200019', '000000', null, null, null, null, 'M', '001', 'BWB', 188009700, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200016', '000000', null, null, null, null, 'M', '001', 'BWB', 947749200, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200001', '000000', null, null, null, null, 'M', '001', 'BWB', .856403, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200093', '000000', null, null, null, null, 'M', '001', 'BWB', 2.619643, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200003', '000000', null, null, null, null, 'M', '001', 'BWB', 305.8891, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100005', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100006', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100007', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100001', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100002', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100003', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100004', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100011', '000000', null, null, null, null, 'M', '001', 'BWB', 17339000000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100149', '000000', null, null, null, null, 'M', '001', 'BWB', 12991000000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200014', '000000', null, null, null, null, 'M', '001', 'BWB', 111714810000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200015', '000000', null, null, null, null, 'M', '001', 'BWB', 962754500, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200017', '000000', null, null, null, null, 'M', '001', 'BWB', 194998100, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200018', '000000', null, null, null, null, 'M', '001', 'BWB', 538375000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200019', '000000', null, null, null, null, 'M', '001', 'BWB', 212734200, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200016', '000000', null, null, null, null, 'M', '001', 'BWB', 946107300, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200001', '000000', null, null, null, null, 'M', '001', 'BWB', .832667, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200093', '000000', null, null, null, null, 'M', '001', 'BWB', 2.543561, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200003', '000000', null, null, null, null, 'M', '001', 'BWB', 305.4714, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100005', '000000', null, null, null, null, 'M', '001', 'BWB', 22254658000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100006', '000000', null, null, null, null, 'M', '001', 'BWB', 15416587000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100007', '000000', null, null, null, null, 'M', '001', 'BWB', 15416587000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100001', '000000', null, null, null, null, 'M', '001', 'BWB', 13.9652, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100002', '000000', null, null, null, null, 'M', '001', 'BWB', 9.6742, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100003', '000000', null, null, null, null, 'M', '001', 'BWB', 9.6742, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100004', '000000', null, null, null, null, 'M', '001', 'BWB', 5.135618, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100011', '000000', null, null, null, null, 'M', '001', 'BWB', 18902000000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100149', '000000', null, null, null, null, 'M', '001', 'BWB', 14300000000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
commit;
prompt 700 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200014', '000000', null, null, null, null, 'M', '001', 'BWB', 127076900000, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200015', '000000', null, null, null, null, 'M', '001', 'BWB', 1060150000, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200017', '000000', null, null, null, null, 'M', '001', 'BWB', 172078100, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200018', '000000', null, null, null, null, 'M', '001', 'BWB', 549269100, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200019', '000000', null, null, null, null, 'M', '001', 'BWB', 239944400, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200016', '000000', null, null, null, null, 'M', '001', 'BWB', 961291600, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200001', '000000', null, null, null, null, 'M', '001', 'BWB', .74462, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200093', '000000', null, null, null, null, 'M', '001', 'BWB', 2.499598, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200003', '000000', null, null, null, null, 'M', '001', 'BWB', 335.6879, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100005', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100006', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100007', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100001', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100002', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100003', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100004', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100011', '000000', null, null, null, null, 'M', '001', 'BWB', 17923000000, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100149', '000000', null, null, null, null, 'M', '001', 'BWB', 14290000000, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200014', '000000', null, null, null, null, 'M', '001', 'BWB', 127700990000, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200015', '000000', null, null, null, null, 'M', '001', 'BWB', 1349985700, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200017', '000000', null, null, null, null, 'M', '001', 'BWB', 201386000, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200018', '000000', null, null, null, null, 'M', '001', 'BWB', 561499100, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200019', '000000', null, null, null, null, 'M', '001', 'BWB', 276182400, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200016', '000000', null, null, null, null, 'M', '001', 'BWB', 1039067600, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200001', '000000', null, null, null, null, 'M', '001', 'BWB', .79873, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200093', '000000', null, null, null, null, 'M', '001', 'BWB', 2.629803, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200003', '000000', null, null, null, null, 'M', '001', 'BWB', 329.2482, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100005', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100006', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100007', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100001', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100002', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100003', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0100004', '000000', null, null, null, null, 'M', '001', 'BWB', null, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100011', '000000', null, null, null, null, 'M', '001', 'BWB', 17641000000, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100149', '000000', null, null, null, null, 'M', '001', 'BWB', 15671000000, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200014', '000000', null, null, null, null, 'M', '001', 'BWB', 135101110000, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200015', '000000', null, null, null, null, 'M', '001', 'BWB', 894931500, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200017', '000000', null, null, null, null, 'M', '001', 'BWB', 245245900, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200018', '000000', null, null, null, null, 'M', '001', 'BWB', 495302600, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('RM0200019', '000000', null, null, null, null, 'M', '001', 'BWB', 278843100, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '001', 'BWB', 16238889040, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '001', 'BWB', 16202045730, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '002', 'BWB', 16090604600, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '002', 'BWB', 16052147360, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '801', null, null, null, null, 'M', '001', 'BWB', 15996643570, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '002', 'BWB', 15895366810, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '001', 'BWB', 15803795300, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '001', 'BWB', 15680727230, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '002', 'BWB', 15459717410, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '002', 'BWB', 15421825630, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '001', 'BWB', 15293304710, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '001', 'BWB', 15288152290, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '002', 'BWB', 15286767840, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '002', 'BWB', 15237585470, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '001', 'BWB', 15236145290, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '002', 'BWB', 15200051200, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '001', 'BWB', 15125011730, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '002', 'BWB', 15067689360, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '001', 'BWB', 15020582640, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '002', 'BWB', 14824147870, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '002', 'BWB', 14749457270, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '002', 'BWB', 14741990670, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '001', 'BWB', 14710357560, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '001', 'BWB', 14682033910, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '002', 'BWB', 14680511410, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '801', null, null, null, null, 'M', '001', 'BWB', 14582015660, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '002', 'BWB', 14404805290, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '002', 'BWB', 14375944150, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '001', 'BWB', 14364968460, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '001', 'BWB', 14278651660, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '001', 'BWB', 14189684720, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '001', 'BWB', 14140412000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '001', 'BWB', 14118312450, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '002', 'BWB', 14021175800, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '002', 'BWB', 14019339210, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '001', 'BWB', 13951937990, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '002', 'BWB', 13927933480, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '002', 'BWB', 13918056600, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '002', 'BWB', 13873240130, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '001', 'BWB', 13833031340, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '001', 'BWB', 13713361660, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '001', 'BWB', 13705787860, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '002', 'BWB', 13694350580, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '002', 'BWB', 13675526060, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '001', 'BWB', 13667631610, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '001', 'BWB', 13567980630, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '001', 'BWB', 13538537050, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '001', 'BWB', 13505729530, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '002', 'BWB', 13499574600, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '002', 'BWB', 13484510680, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '002', 'BWB', 13453946930, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '001', 'BWB', 13323017830, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '001', 'BWB', 13265628060, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '002', 'BWB', 13196736330, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '001', 'BWB', 13179572690, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '001', 'BWB', 13160178290, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '002', 'BWB', 13129581890, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '002', 'BWB', 13124708570, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '002', 'BWB', 12966174770, to_date('31-10-2019', 'dd-mm-yyyy'), null);
commit;
prompt 800 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '001', 'BWB', 12905032600, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '002', 'BWB', 12903538300, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '002', 'BWB', 12863420330, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '002', 'BWB', 12785148370, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '001', 'BWB', 12773520040, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '002', 'BWB', 12752949530, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '001', 'BWB', 12695109840, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '001', 'BWB', 12573479170, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '002', 'BWB', 12537600640, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '806', null, null, null, null, 'M', '001', 'BWB', 12527469140, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '001', 'BWB', 12525819880, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '803', null, null, null, null, 'M', '001', 'BWB', 12512075770, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '002', 'BWB', 12444390800, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '002', 'BWB', 12430340160, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '002', 'BWB', 12353083930, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '002', 'BWB', 12190162780, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '001', 'BWB', 12168787730, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '002', 'BWB', 12141569630, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '001', 'BWB', 12131751240, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '002', 'BWB', 12075075840, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '002', 'BWB', 12051197740, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '806', null, null, null, null, 'M', '001', 'BWB', 12032452030, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '803', null, null, null, null, 'M', '001', 'BWB', 11981056250, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '001', 'BWB', 11924274770, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '001', 'BWB', 11922578050, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '001', 'BWB', 0, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '001', 'BWB', 0, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '001', 'BWB', 0, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '001', 'BWB', 0, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '001', 'BWB', 219564034200, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '002', 'BWB', 216316753700, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '001', 'BWB', 214280393100, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '002', 'BWB', 207647109100, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '001', 'BWB', 207395246500, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '002', 'BWB', 204175184000, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '001', 'BWB', 202846644900, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '001', 'BWB', 201706913900, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '002', 'BWB', 196409448700, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '001', 'BWB', 196406288800, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '002', 'BWB', 195572033200, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '001', 'BWB', 190936564100, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '002', 'BWB', 189695127500, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '001', 'BWB', 186302184600, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '002', 'BWB', 185824850300, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '002', 'BWB', 180725326100, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '001', 'BWB', 180194539300, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '002', 'BWB', 179785399200, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '002', 'BWB', 170965082300, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '001', 'BWB', 170203981000, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '001', 'BWB', 169024148600, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '001', 'BWB', 163743634200, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '002', 'BWB', 163295900500, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '002', 'BWB', 163294502100, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '001', 'BWB', 159168532400, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '001', 'BWB', 159131543500, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '001', 'BWB', 154000618200, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '002', 'BWB', 153964893200, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '002', 'BWB', 153536577200, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '002', 'BWB', 153299981000, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '001', 'BWB', 149622685100, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '001', 'BWB', 147098040600, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '001', 'BWB', 144587798800, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '002', 'BWB', 144584736100, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '002', 'BWB', 144560146400, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '002', 'BWB', 144421026700, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '001', 'BWB', 143600027700, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '001', 'BWB', 142958478800, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '002', 'BWB', 142422614200, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '001', 'BWB', 137438097200, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '002', 'BWB', 137188899800, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '001', 'BWB', 136872694500, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '002', 'BWB', 136057846900, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '001', 'BWB', 136035566000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '002', 'BWB', 135801878500, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '001', 'BWB', 134534998900, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '001', 'BWB', 134500243600, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '002', 'BWB', 133242973000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '000000', null, null, null, null, 'M', '002', 'BWB', 131956590600, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '002', 'BWB', 128845616200, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '001', 'BWB', 128437661900, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '000000', null, null, null, null, 'M', '002', 'BWB', 123983386100, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '001', 'BWB', 119450049100, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '001', 'BWB', 116472461700, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '002', 'BWB', 115406122700, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '002', 'BWB', 112253158000, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '001', 'BWB', 110488476700, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '002', 'BWB', 109884116500, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '001', 'BWB', 107124516200, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '001', 'BWB', 106616155400, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '002', 'BWB', 106443236600, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '001', 'BWB', 105210820300, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '002', 'BWB', 104634712600, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '001', 'BWB', 103815010900, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '001', 'BWB', 103791916400, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '002', 'BWB', 103664947700, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '001', 'BWB', 102113262700, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '002', 'BWB', 101868768500, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '002', 'BWB', 100910631000, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '002', 'BWB', 100858017100, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '001', 'BWB', 100113985100, to_date('31-07-2020', 'dd-mm-yyyy'), null);
commit;
prompt 900 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '002', 'BWB', 97762992550, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '001', 'BWB', 97635824620, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '001', 'BWB', 95477340430, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '001', 'BWB', 94582397690, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '002', 'BWB', 93743317900, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '001', 'BWB', 93351258430, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '002', 'BWB', 91922026020, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '002', 'BWB', 91774736180, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '001', 'BWB', 90922784800, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '002', 'BWB', 90813091460, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '001', 'BWB', 89790133450, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '002', 'BWB', 89128796640, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '001', 'BWB', 88823301420, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '002', 'BWB', 86982008230, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '001', 'BWB', 86897911300, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '002', 'BWB', 86779917560, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '002', 'BWB', 86030179790, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '001', 'BWB', 85900022890, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '001', 'BWB', 85176391430, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '002', 'BWB', 84875467210, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '001', 'BWB', 84717198840, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '002', 'BWB', 83956081780, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '001', 'BWB', 83124125670, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '001', 'BWB', 82487173690, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '001', 'BWB', 80890570610, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '002', 'BWB', 80151990830, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '002', 'BWB', 79932647400, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '001', 'BWB', 79338174250, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '002', 'BWB', 79255851440, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '002', 'BWB', 78927382020, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '002', 'BWB', 78420433250, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '001', 'BWB', 78240972870, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '002', 'BWB', 77853778180, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '001', 'BWB', 76852722530, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '001', 'BWB', 76845722950, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '002', 'BWB', 76514584560, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '001', 'BWB', 75811587250, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '001', 'BWB', 75616392330, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '002', 'BWB', 75580034550, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '002', 'BWB', 75446202780, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '002', 'BWB', 75335121250, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '002', 'BWB', 74920385980, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '001', 'BWB', 74845895570, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '002', 'BWB', 74709041810, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '001', 'BWB', 74662443950, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '002', 'BWB', 74534877470, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '001', 'BWB', 74006292730, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '001', 'BWB', 73992141000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '002', 'BWB', 73603929830, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '001', 'BWB', 73000822270, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '001', 'BWB', 72311381250, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '002', 'BWB', 72185324450, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '001', 'BWB', 72069820960, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '001', 'BWB', 71644675480, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '002', 'BWB', 71632004080, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '001', 'BWB', 71586976540, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '002', 'BWB', 71293475220, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '001', 'BWB', 71286453320, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '001', 'BWB', 70888657830, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '002', 'BWB', 70025268950, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '000000', null, null, null, null, 'M', '001', 'BWB', 69889311230, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '000000', null, null, null, null, 'M', '002', 'BWB', 69593162260, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '001', 'BWB', 69373202790, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '000000', null, null, null, null, 'M', '002', 'BWB', 69249614890, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '805', null, null, null, null, 'M', '002', 'BWB', 69093666720, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '000000', null, null, null, null, 'M', '002', 'BWB', 68840992140, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '001', 'BWB', 8952882305, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '002', 'BWB', 8933994273, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '001', 'BWB', 8921903673, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '001', 'BWB', 8905446948, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '001', 'BWB', 8893255442, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '001', 'BWB', 8891645288, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '001', 'BWB', 8870567700, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '002', 'BWB', 8850650997, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '002', 'BWB', 8849532281, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '002', 'BWB', 8836529570, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '001', 'BWB', 8835553195, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '001', 'BWB', 8826792948, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '001', 'BWB', 8812523203, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '002', 'BWB', 8796197692, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '002', 'BWB', 8782857596, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '002', 'BWB', 8778160109, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '002', 'BWB', 8774545375, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '002', 'BWB', 8735826892, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '002', 'BWB', 8720035140, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '001', 'BWB', 8697989148, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '002', 'BWB', 8692358109, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '001', 'BWB', 8677085111, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '002', 'BWB', 8675335009, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '002', 'BWB', 8672191894, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '001', 'BWB', 8654048224, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '002', 'BWB', 8634195907, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '002', 'BWB', 8614709152, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '001', 'BWB', 8577316017, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '001', 'BWB', 8572242442, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '002', 'BWB', 8562433514, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '001', 'BWB', 8552232845, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '001', 'BWB', 8542866562, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '002', 'BWB', 8542277379, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '001', 'BWB', 8506570464, to_date('31-05-2020', 'dd-mm-yyyy'), null);
commit;
prompt 1000 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '001', 'BWB', 8505937504, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '002', 'BWB', 8502299473, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '001', 'BWB', 8493810448, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '002', 'BWB', 8493293261, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '002', 'BWB', 8468751367, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '002', 'BWB', 8461720788, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '001', 'BWB', 8435032543, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '001', 'BWB', 8423479904, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '002', 'BWB', 8419640311, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '002', 'BWB', 8415202661, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '001', 'BWB', 8410018719, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '002', 'BWB', 8404297907, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '002', 'BWB', 8392190109, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '001', 'BWB', 8386511334, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '002', 'BWB', 8369899002, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '002', 'BWB', 8348792929, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '002', 'BWB', 8343283606, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '001', 'BWB', 8336740470, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '001', 'BWB', 8316579442, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '001', 'BWB', 8302179205, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '001', 'BWB', 8299248736, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '001', 'BWB', 8298828800, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '002', 'BWB', 8294627638, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '001', 'BWB', 8287708470, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '002', 'BWB', 8287011607, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '001', 'BWB', 8267266663, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '001', 'BWB', 8250727848, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '001', 'BWB', 8227002800, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '001', 'BWB', 8222614789, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '002', 'BWB', 8186805528, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '001', 'BWB', 8184399543, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '002', 'BWB', 4022965425, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '002', 'BWB', 4003525382, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '002', 'BWB', 4001280089, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '002', 'BWB', 3999717512, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '002', 'BWB', 3996382369, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '001', 'BWB', 3981521252, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '001', 'BWB', 3976620300, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '002', 'BWB', 3970543770, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '001', 'BWB', 3967326524, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '001', 'BWB', 3953171293, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '002', 'BWB', 3947626852, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '001', 'BWB', 3928617934, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '001', 'BWB', 3904446539, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '001', 'BWB', 3902577000, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '002', 'BWB', 3896884816, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '001', 'BWB', 3884268610, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '001', 'BWB', 3882482978, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '002', 'BWB', 3882214989, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '002', 'BWB', 3863024341, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '001', 'BWB', 3811446630, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '002', 'BWB', 3764993720, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '002', 'BWB', 3763735681, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '001', 'BWB', 3759070300, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '002', 'BWB', 3753267779, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '002', 'BWB', 3743986473, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '001', 'BWB', 3740334205, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '001', 'BWB', 3740195989, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '002', 'BWB', 3736561690, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '002', 'BWB', 3733634344, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '001', 'BWB', 3725514000, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '002', 'BWB', 3723179692, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '002', 'BWB', 3715024300, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '001', 'BWB', 3699963260, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '002', 'BWB', 3689497552, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '001', 'BWB', 3683953000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '002', 'BWB', 3663179645, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '002', 'BWB', 3642038290, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '001', 'BWB', 3631658288, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '001', 'BWB', 3627637943, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '002', 'BWB', 3612921935, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '001', 'BWB', 3612460000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '001', 'BWB', 3602794843, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '002', 'BWB', 3602118337, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '002', 'BWB', 3601620528, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '001', 'BWB', 3597543387, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '001', 'BWB', 3517634000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '001', 'BWB', 3500206000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '002', 'BWB', 3476920360, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '001', 'BWB', 3473808988, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '002', 'BWB', 3464249806, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '002', 'BWB', 3463344072, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '001', 'BWB', 3457299523, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '002', 'BWB', 3448539121, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '002', 'BWB', 3440879934, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '001', 'BWB', 3430993108, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '002', 'BWB', 3423309919, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '002', 'BWB', 3422824822, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '002', 'BWB', 3412002618, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '002', 'BWB', 3388405603, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '001', 'BWB', 3383920630, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '001', 'BWB', 3363960484, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '002', 'BWB', 3357692731, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '002', 'BWB', 3357670830, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '002', 'BWB', 3351991062, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '001', 'BWB', 3345870879, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '001', 'BWB', 3320785546, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '001', 'BWB', 3319229694, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '001', 'BWB', 3312492194, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '001', 'BWB', 3308962680, to_date('30-06-2020', 'dd-mm-yyyy'), null);
commit;
prompt 1100 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '002', 'BWB', 3302356056, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '001', 'BWB', 3302187778, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '002', 'BWB', 3291148658, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '001', 'BWB', 3290198320, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '002', 'BWB', 3288381900, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '001', 'BWB', 3280495989, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '001', 'BWB', 3278508717, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '002', 'BWB', 3278498181, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '002', 'BWB', 3264112523, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '001', 'BWB', 3263368924, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '002', 'BWB', 3255269110, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '002', 'BWB', 3254567068, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '002', 'BWB', 3249441991, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '002', 'BWB', 3241402251, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '002', 'BWB', 3239759733, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '001', 'BWB', 3225266369, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '001', 'BWB', 3220233366, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '002', 'BWB', 3209292574, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '001', 'BWB', 3201220089, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '001', 'BWB', 3193204768, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '001', 'BWB', 3185134771, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '002', 'BWB', 3182212813, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '001', 'BWB', 3177146731, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '001', 'BWB', 3166809151, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '002', 'BWB', 3161687051, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '002', 'BWB', 3152964678, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '002', 'BWB', 3149796796, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '001', 'BWB', 3141533699, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '001', 'BWB', 3137043092, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '002', 'BWB', 3134739215, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '002', 'BWB', 3133826259, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '002', 'BWB', 3113594561, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '001', 'BWB', 3111855075, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '001', 'BWB', 3111511045, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '001', 'BWB', 3107279275, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '001', 'BWB', 3101358280, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '002', 'BWB', 3100238128, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '002', 'BWB', 3097959256, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '001', 'BWB', 3097557600, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '001', 'BWB', 3090816436, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '001', 'BWB', 3087365164, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '002', 'BWB', 3084346003, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '001', 'BWB', 3075976074, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '002', 'BWB', 3066549795, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '001', 'BWB', 3056169186, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '001', 'BWB', 3039512917, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '001', 'BWB', 3028375906, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '001', 'BWB', 3027122106, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '002', 'BWB', 3004935440, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '002', 'BWB', 3004070562, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '001', 'BWB', 3004042653, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '001', 'BWB', 3000599000, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '002', 'BWB', 2997184588, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '001', 'BWB', 2995426000, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '002', 'BWB', 2994864401, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '001', 'BWB', 2993677215, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '001', 'BWB', 2977587408, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '002', 'BWB', 2974230471, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '001', 'BWB', 2969912602, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '002', 'BWB', 2969662613, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '002', 'BWB', 2968411723, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '001', 'BWB', 2967382215, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '002', 'BWB', 2963974387, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '001', 'BWB', 2961526065, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '002', 'BWB', 2960642523, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '001', 'BWB', 2959501464, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '002', 'BWB', 2957048603, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '002', 'BWB', 2954536226, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '001', 'BWB', 2954503855, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '002', 'BWB', 2953887823, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '001', 'BWB', 2952611065, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '001', 'BWB', 2952604464, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '001', 'BWB', 2951780000, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '001', 'BWB', 2951463159, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '001', 'BWB', 2945426000, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '002', 'BWB', 2943749333, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '002', 'BWB', 2942191093, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '002', 'BWB', 2932742541, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '002', 'BWB', 2930878838, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '002', 'BWB', 2930226435, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '001', 'BWB', 2928857490, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '002', 'BWB', 8171807430, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '001', 'BWB', 8164647762, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '002', 'BWB', 8137692456, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '001', 'BWB', 8133201628, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '002', 'BWB', 8108371781, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '001', 'BWB', 8086256790, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '002', 'BWB', 8076085295, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '001', 'BWB', 8072519700, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '001', 'BWB', 8070525223, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '002', 'BWB', 8053537255, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '001', 'BWB', 8021072628, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '002', 'BWB', 8013333515, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '001', 'BWB', 8004804442, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '001', 'BWB', 7999862087, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '001', 'BWB', 7995620822, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '002', 'BWB', 7984147813, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '001', 'BWB', 7982095789, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '002', 'BWB', 7980166801, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '002', 'BWB', 7979061231, to_date('31-03-2020', 'dd-mm-yyyy'), null);
commit;
prompt 1200 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '002', 'BWB', 7973285239, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '000000', null, null, null, null, 'M', '002', 'BWB', 7973204570, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '001', 'BWB', 7956475019, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '002', 'BWB', 7906255076, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '001', 'BWB', 7899973700, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '002', 'BWB', 7893733524, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '001', 'BWB', 7892570539, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '002', 'BWB', 7872613460, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '001', 'BWB', 7864476306, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '001', 'BWB', 7861160828, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '001', 'BWB', 7859725470, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '002', 'BWB', 7857056226, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '002', 'BWB', 7856040413, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '002', 'BWB', 7847391424, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '001', 'BWB', 7846833948, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '002', 'BWB', 7841160828, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '001', 'BWB', 7827820599, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '001', 'BWB', 7820330316, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '001', 'BWB', 7820065935, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '002', 'BWB', 7818654401, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '002', 'BWB', 7816838206, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '001', 'BWB', 7816057587, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '001', 'BWB', 7811160828, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '002', 'BWB', 7810094565, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '001', 'BWB', 7806723020, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '001', 'BWB', 7791823277, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '002', 'BWB', 7785545436, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '002', 'BWB', 7771953684, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '002', 'BWB', 7766072768, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '001', 'BWB', 7752302705, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '002', 'BWB', 7746927890, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '001', 'BWB', 7746821700, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '001', 'BWB', 7737470915, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '002', 'BWB', 7724880328, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '002', 'BWB', 7721670089, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '002', 'BWB', 7718322397, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '002', 'BWB', 7716310328, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '001', 'BWB', 7710782948, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '002', 'BWB', 7706056719, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '002', 'BWB', 7703347530, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '001', 'BWB', 7695359642, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '001', 'BWB', 7695098237, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '001', 'BWB', 7687763766, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '001', 'BWB', 7682450539, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '002', 'BWB', 7666120127, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '002', 'BWB', 7662123010, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '001', 'BWB', 7659050020, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '002', 'BWB', 7650565712, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '001', 'BWB', 7649951062, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '002', 'BWB', 7628820576, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '001', 'BWB', 7612635005, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '802', null, null, null, null, 'M', '001', 'BWB', 7605790834, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '001', 'BWB', 7604372062, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '001', 'BWB', 7600981953, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '002', 'BWB', 7579458008, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '002', 'BWB', 7577207847, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '002', 'BWB', 7562842266, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '001', 'BWB', 7561373594, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '001', 'BWB', 7561057155, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '001', 'BWB', 7559737053, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '001', 'BWB', 7557023700, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '002', 'BWB', 7537237604, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '001', 'BWB', 7530164292, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '002', 'BWB', 7521260358, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '002', 'BWB', 7519263069, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '002', 'BWB', 7518406974, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '001', 'BWB', 7516502185, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '002', 'BWB', 1533355021, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '001', 'BWB', 1524746744, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '001', 'BWB', 1513905697, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '002', 'BWB', 1494453840, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '002', 'BWB', 1485492107, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '002', 'BWB', 1465502241, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '001', 'BWB', 1456385500, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '002', 'BWB', 1454508851, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '001', 'BWB', 1427479535, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '002', 'BWB', 1421798581, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '001', 'BWB', 1414627910, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '002', 'BWB', 1410810272, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '001', 'BWB', 1409379381, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '002', 'BWB', 1407888886, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '001', 'BWB', 1403186875, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '002', 'BWB', 1401551449, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '001', 'BWB', 1396713671, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '001', 'BWB', 1396308749, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '002', 'BWB', 1395203485, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '002', 'BWB', 1377891783, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '002', 'BWB', 1372861796, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '001', 'BWB', 1372347001, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '002', 'BWB', 1368519881, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '001', 'BWB', 1367569384, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '002', 'BWB', 1359918055, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '002', 'BWB', 1350148102, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '002', 'BWB', 1347758767, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '002', 'BWB', 1347236173, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '001', 'BWB', 1336017570, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '002', 'BWB', 1322930784, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '002', 'BWB', 1321662400, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '001', 'BWB', 1320800957, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '002', 'BWB', 1315967442, to_date('30-11-2019', 'dd-mm-yyyy'), null);
commit;
prompt 1300 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '001', 'BWB', 1315539045, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '001', 'BWB', 1310089681, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '001', 'BWB', 1298833654, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '002', 'BWB', 1296289715, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '001', 'BWB', 1287623802, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '002', 'BWB', 1279476326, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '001', 'BWB', 1278457356, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '001', 'BWB', 1276605000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '002', 'BWB', 1274914619, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '001', 'BWB', 1269877382, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '001', 'BWB', 1266699334, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '001', 'BWB', 1265487249, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '001', 'BWB', 1255228547, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '002', 'BWB', 1251293064, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '002', 'BWB', 1250761189, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '001', 'BWB', 1248012416, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '002', 'BWB', 1247499429, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '002', 'BWB', 1242374194, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '001', 'BWB', 1240067506, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '002', 'BWB', 1235464226, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '001', 'BWB', 1222376158, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '001', 'BWB', 1221344997, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '002', 'BWB', 1214487226, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '001', 'BWB', 1207315020, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '002', 'BWB', 1204704638, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '001', 'BWB', 1201335606, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '001', 'BWB', 1193290866, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '002', 'BWB', 1189214137, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '001', 'BWB', 1184565192, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '001', 'BWB', 1177624855, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '002', 'BWB', 1172607120, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '001', 'BWB', 1170737955, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '001', 'BWB', 1168708642, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '002', 'BWB', 1152675681, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '002', 'BWB', 1152091833, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '001', 'BWB', 1150816244, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '001', 'BWB', 1145839879, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '002', 'BWB', 1141861421, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '002', 'BWB', 1139873893, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '001', 'BWB', 1131113702, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '001', 'BWB', 1129431858, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '001', 'BWB', 1124897394, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '001', 'BWB', 1124334000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '002', 'BWB', 1120971248, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '001', 'BWB', 1120631547, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '001', 'BWB', 1115863256, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '002', 'BWB', 1110722796, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '002', 'BWB', 1106621674, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '001', 'BWB', 1105363810, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '002', 'BWB', 1104899774, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '002', 'BWB', 1104566024, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '001', 'BWB', 1102393158, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '002', 'BWB', 1101111593, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '002', 'BWB', 1100221394, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '001', 'BWB', 1100214000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '002', 'BWB', 1100176477, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '002', 'BWB', 1097654549, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '002', 'BWB', 1094559217, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '001', 'BWB', 1090991020, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '002', 'BWB', 1085448227, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '002', 'BWB', 1082141295, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '002', 'BWB', 1079765142, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '001', 'BWB', 1078916412, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '001', 'BWB', 1076103158, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '001', 'BWB', 1075430000, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '002', 'BWB', 1071787263, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '002', 'BWB', 1062323600, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '001', 'BWB', 1060009381, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '002', 'BWB', 1059799710, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '002', 'BWB', 1058130668, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '001', 'BWB', 1057312000, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '001', 'BWB', 1055171384, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '001', 'BWB', 1053062000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '001', 'BWB', 1052123158, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '001', 'BWB', 1049542001, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '001', 'BWB', 1047466221, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '002', 'BWB', 1046085693, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '001', 'BWB', 1044010000, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '001', 'BWB', 1042195670, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '001', 'BWB', 1039809158, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '001', 'BWB', 1029681524, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '002', 'BWB', 1029396191, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '001', 'BWB', 1028910186, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '001', 'BWB', 1022437000, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '001', 'BWB', 1018502043, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '002', 'BWB', 1018046312, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '001', 'BWB', 1015222879, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '001', 'BWB', 1014722059, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '002', 'BWB', 1013978421, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '002', 'BWB', 1013495168, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '002', 'BWB', 1010865887, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '002', 'BWB', 1006415688, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '001', 'BWB', 1004288259, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '002', 'BWB', 999724567, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '002', 'BWB', 997797264, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '002', 'BWB', 996792163, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '002', 'BWB', 994472258, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '002', 'BWB', 972247926, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '001', 'BWB', 970369670, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '002', 'BWB', 969754124, to_date('30-06-2020', 'dd-mm-yyyy'), null);
commit;
prompt 1400 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '002', 'BWB', 966245590, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '002', 'BWB', 961082397, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '001', 'BWB', 960839308, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '001', 'BWB', 960635000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '002', 'BWB', 957623104, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '001', 'BWB', 949610000, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '001', 'BWB', 946844000, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '002', 'BWB', 939831793, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '001', 'BWB', 939259813, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '002', 'BWB', 937214987, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '002', 'BWB', 927941868, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '001', 'BWB', 927188000, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '001', 'BWB', 926968300, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '002', 'BWB', 919342019, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '002', 'BWB', 918526681, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '001', 'BWB', 914696506, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '001', 'BWB', 913893440, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '002', 'BWB', 899392226, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '002', 'BWB', 896214386, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '001', 'BWB', 895224000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '002', 'BWB', 894565729, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '001', 'BWB', 888505158, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '002', 'BWB', 876217140, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '002', 'BWB', 875917121, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '001', 'BWB', 873153158, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '001', 'BWB', 872003000, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '001', 'BWB', 871176829, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '001', 'BWB', 870866852, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '001', 'BWB', 868170963, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '002', 'BWB', 866624797, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '001', 'BWB', 865600000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '001', 'BWB', 865078027, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '002', 'BWB', 864622730, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '002', 'BWB', 861641320, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '001', 'BWB', 860420000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '001', 'BWB', 859303158, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '002', 'BWB', 856486833, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '002', 'BWB', 856449825, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '002', 'BWB', 852096155, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '001', 'BWB', 843427207, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '001', 'BWB', 842304000, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '002', 'BWB', 839872720, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '002', 'BWB', 832987848, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '002', 'BWB', 830930246, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '001', 'BWB', 830897917, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '002', 'BWB', 818185655, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '001', 'BWB', 804741141, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '001', 'BWB', 800755260, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '002', 'BWB', 795726100, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '001', 'BWB', 792463794, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '002', 'BWB', 776011992, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '002', 'BWB', 775542019, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '002', 'BWB', 771657419, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '002', 'BWB', 771624643, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '001', 'BWB', 766965387, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '001', 'BWB', 762061568, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '001', 'BWB', 755311202, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '002', 'BWB', 752345523, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '002', 'BWB', 751444634, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '001', 'BWB', 748381448, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '001', 'BWB', 746851171, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '001', 'BWB', 745716158, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '002', 'BWB', 741227580, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '001', 'BWB', 740215645, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '001', 'BWB', 739808184, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '002', 'BWB', 736984460, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '002', 'BWB', 736907196, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '001', 'BWB', 732251981, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '002', 'BWB', 731853621, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '002', 'BWB', 729126164, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '002', 'BWB', 728905758, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '002', 'BWB', 727686170, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '002', 'BWB', 725052221, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '002', 'BWB', 719430311, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '001', 'BWB', 717937000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '002', 'BWB', 717214983, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '001', 'BWB', 717070090, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '001', 'BWB', 715045963, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '002', 'BWB', 711431607, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '002', 'BWB', 710945972, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '001', 'BWB', 708966497, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '002', 'BWB', 705990813, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '002', 'BWB', 705891508, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '002', 'BWB', 704262786, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '002', 'BWB', 702792430, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '002', 'BWB', 701751793, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '001', 'BWB', 700735440, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '001', 'BWB', 700199158, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '002', 'BWB', 699769490, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '803', null, null, null, null, 'M', '002', 'BWB', 699362315, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '001', 'BWB', 698747568, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '001', 'BWB', 698630829, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '001', 'BWB', 697883000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '002', 'BWB', 697662501, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '002', 'BWB', 695899423, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '001', 'BWB', 695713494, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '001', 'BWB', 695492680, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '001', 'BWB', 692393124, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '001', 'BWB', 690956224, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '002', 'BWB', 690855551, to_date('31-07-2020', 'dd-mm-yyyy'), null);
commit;
prompt 1500 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '001', 'BWB', 690824380, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '001', 'BWB', 689670693, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '002', 'BWB', 684554600, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '001', 'BWB', 679889000, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '002', 'BWB', 679834956, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '001', 'BWB', 678783565, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '002', 'BWB', 678460472, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '002', 'BWB', 677827163, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '808', null, null, null, null, 'M', '001', 'BWB', 674760937, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '002', 'BWB', 674755768, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '002', 'BWB', 670920900, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '002', 'BWB', 664598359, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '002', 'BWB', 664579281, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '001', 'BWB', 657110000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '001', 'BWB', 650580000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '002', 'BWB', 645317213, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '001', 'BWB', 641924224, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '001', 'BWB', 641099917, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '001', 'BWB', 639826308, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '001', 'BWB', 639454494, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '002', 'BWB', 638064196, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '002', 'BWB', 636076502, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '001', 'BWB', 629915908, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '002', 'BWB', 622250672, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '002', 'BWB', 616375567, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '001', 'BWB', 616241810, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '002', 'BWB', 616227326, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '002', 'BWB', 611776259, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '001', 'BWB', 611270804, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '001', 'BWB', 611020052, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '002', 'BWB', 607951404, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '001', 'BWB', 607804058, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '002', 'BWB', 606256427, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '001', 'BWB', 605156000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '802', null, null, null, null, 'M', '001', 'BWB', 604879275, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '001', 'BWB', 602631058, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '001', 'BWB', 601387000, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '001', 'BWB', 600515837, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '002', 'BWB', 596491680, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '001', 'BWB', 589092693, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '002', 'BWB', 587995549, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '002', 'BWB', 581865069, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '001', 'BWB', 580545158, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '001', 'BWB', 578239565, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '002', 'BWB', 577524077, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '001', 'BWB', 569841000, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '001', 'BWB', 567697000, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '001', 'BWB', 566293158, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '001', 'BWB', 565856000, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '002', 'BWB', 565392277, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '001', 'BWB', 565063619, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '002', 'BWB', 561727497, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '002', 'BWB', 558997491, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '002', 'BWB', 558674419, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '001', 'BWB', 555209908, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '002', 'BWB', 553756233, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '001', 'BWB', 553183374, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '001', 'BWB', 553117000, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '002', 'BWB', 550800577, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '001', 'BWB', 550589402, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '001', 'BWB', 550331823, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '002', 'BWB', 548033867, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '002', 'BWB', 547785346, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '001', 'BWB', 547763158, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '002', 'BWB', 545944176, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '001', 'BWB', 542923158, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '002', 'BWB', 537157233, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '002', 'BWB', 534972765, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '001', 'BWB', 7504537727, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '002', 'BWB', 7497032055, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '002', 'BWB', 7476985287, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '002', 'BWB', 7467379309, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '001', 'BWB', 7453724434, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '001', 'BWB', 7452161337, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '001', 'BWB', 7450031243, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '001', 'BWB', 7441292062, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '002', 'BWB', 7440801720, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '002', 'BWB', 7436733340, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '001', 'BWB', 7433248442, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '002', 'BWB', 7424547211, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '002', 'BWB', 7422260989, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '001', 'BWB', 7414946484, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '001', 'BWB', 7389680292, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '002', 'BWB', 7377911010, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '002', 'BWB', 7368390542, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '002', 'BWB', 7363708589, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '002', 'BWB', 7362238820, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '002', 'BWB', 7357419748, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '002', 'BWB', 7355010633, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '001', 'BWB', 7347466428, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '002', 'BWB', 7336842876, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '001', 'BWB', 7314437620, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '001', 'BWB', 7309539812, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '002', 'BWB', 7307988786, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '001', 'BWB', 7302959757, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '001', 'BWB', 7300892357, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '001', 'BWB', 7296951918, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '001', 'BWB', 7295894385, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '002', 'BWB', 7291819317, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '001', 'BWB', 7290384243, to_date('31-10-2019', 'dd-mm-yyyy'), null);
commit;
prompt 1600 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '001', 'BWB', 7280165442, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '001', 'BWB', 7273760937, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '001', 'BWB', 7265331459, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '001', 'BWB', 7247813600, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '001', 'BWB', 7243966656, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '803', null, null, null, null, 'M', '001', 'BWB', 7239011442, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '001', 'BWB', 7238443017, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '002', 'BWB', 7237401821, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '001', 'BWB', 7236232263, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '002', 'BWB', 7219346595, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '001', 'BWB', 7212519155, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '002', 'BWB', 7209082442, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '002', 'BWB', 7203462645, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '002', 'BWB', 7202615077, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '002', 'BWB', 7202575948, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '001', 'BWB', 7193667524, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '002', 'BWB', 7187923776, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '002', 'BWB', 7183919004, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '001', 'BWB', 7182261007, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '001', 'BWB', 7180561254, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '002', 'BWB', 7174251404, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '002', 'BWB', 7168264783, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '001', 'BWB', 7166730442, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '001', 'BWB', 7163625593, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '002', 'BWB', 7150269787, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '002', 'BWB', 7146326807, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '001', 'BWB', 7143564918, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '002', 'BWB', 7137177039, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '002', 'BWB', 7127005818, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '001', 'BWB', 7118320030, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '002', 'BWB', 7102797769, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '001', 'BWB', 7097208062, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '001', 'BWB', 7089217762, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '001', 'BWB', 7075312784, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '002', 'BWB', 7069370765, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '002', 'BWB', 7063186156, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '001', 'BWB', 7061939562, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '001', 'BWB', 7061391830, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '001', 'BWB', 7039244856, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '001', 'BWB', 7032789486, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '002', 'BWB', 7021689024, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '001', 'BWB', 7021461234, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '001', 'BWB', 7020805971, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '001', 'BWB', 7019669524, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '002', 'BWB', 7018687104, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '001', 'BWB', 7018439148, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '002', 'BWB', 7015679276, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '001', 'BWB', 7013052011, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '001', 'BWB', 7010530442, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '002', 'BWB', 6999181201, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '002', 'BWB', 6988726854, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '002', 'BWB', 6976756445, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '002', 'BWB', 6964102341, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '001', 'BWB', 6960762777, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '803', null, null, null, null, 'M', '001', 'BWB', 6954290442, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '002', 'BWB', 6942005983, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '002', 'BWB', 6938573462, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '001', 'BWB', 6920290897, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '001', 'BWB', 6917342720, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '002', 'BWB', 6896479881, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '002', 'BWB', 6888831085, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '001', 'BWB', 6887405333, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '001', 'BWB', 6864401062, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '001', 'BWB', 6860746904, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '002', 'BWB', 6857363489, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '808', null, null, null, null, 'M', '002', 'BWB', 6856889638, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '002', 'BWB', 6854683788, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '002', 'BWB', 6848081684, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '002', 'BWB', 6847270157, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '002', 'BWB', 6843923756, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '002', 'BWB', 6838157430, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '002', 'BWB', 6834258708, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '002', 'BWB', 6830017397, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '002', 'BWB', 6819788684, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '001', 'BWB', 6786192406, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '001', 'BWB', 6783652812, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '002', 'BWB', 6768922831, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '001', 'BWB', 6759389572, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '002', 'BWB', 6749233882, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '002', 'BWB', 6744722937, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '002', 'BWB', 6739823214, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '002', 'BWB', 6710915195, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '001', 'BWB', 6700129076, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '002', 'BWB', 6685472658, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '001', 'BWB', 6670518620, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '001', 'BWB', 6668281207, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '002', 'BWB', 6665921976, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '002', 'BWB', 6663756049, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '001', 'BWB', 6663748830, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '001', 'BWB', 6660909812, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '002', 'BWB', 6644269264, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '001', 'BWB', 6632661021, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '001', 'BWB', 6632181616, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '002', 'BWB', 6630259553, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '002', 'BWB', 6599428777, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '002', 'BWB', 6595352870, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '002', 'BWB', 6584996970, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '001', 'BWB', 6574497455, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '002', 'BWB', 6560883135, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '002', 'BWB', 6559652961, to_date('31-12-2019', 'dd-mm-yyyy'), null);
commit;
prompt 1700 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '002', 'BWB', 6558140487, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '001', 'BWB', 6556473183, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '001', 'BWB', 6536079421, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '002', 'BWB', 6527859310, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '001', 'BWB', 6526522812, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '001', 'BWB', 6519694138, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '002', 'BWB', 6511071763, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '002', 'BWB', 6508607729, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '002', 'BWB', 6491607058, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '001', 'BWB', 6491603057, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '002', 'BWB', 6487831358, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '002', 'BWB', 6483178617, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '001', 'BWB', 6476733323, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '001', 'BWB', 6470128853, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '001', 'BWB', 6464994764, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '002', 'BWB', 6456496944, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '002', 'BWB', 6454829634, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '002', 'BWB', 6449251970, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '002', 'BWB', 6446954780, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '001', 'BWB', 6431817713, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '001', 'BWB', 6430063092, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '001', 'BWB', 6421773697, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '001', 'BWB', 6417584590, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '001', 'BWB', 6411528765, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '001', 'BWB', 6387857764, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '001', 'BWB', 6359672087, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '002', 'BWB', 6346862482, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '001', 'BWB', 6338997436, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '002', 'BWB', 6326973586, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '001', 'BWB', 6320606813, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '002', 'BWB', 6296998652, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '001', 'BWB', 6288833017, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '002', 'BWB', 6286056981, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '002', 'BWB', 6282021416, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '001', 'BWB', 6278559092, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '001', 'BWB', 6277596384, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '001', 'BWB', 6272539420, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '002', 'BWB', 6271754818, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '002', 'BWB', 6265810473, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '001', 'BWB', 6262766371, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '001', 'BWB', 6257972812, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '002', 'BWB', 6246664862, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '001', 'BWB', 6238575878, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '002', 'BWB', 6238424767, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '002', 'BWB', 6235443991, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '001', 'BWB', 6228340003, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '002', 'BWB', 6210938127, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '002', 'BWB', 6193922360, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '001', 'BWB', 6185155470, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '001', 'BWB', 6179452917, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '001', 'BWB', 6177796003, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '002', 'BWB', 6171128705, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '001', 'BWB', 6170491549, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '001', 'BWB', 6159737330, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '002', 'BWB', 6153921835, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '001', 'BWB', 6146130822, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '002', 'BWB', 6145958148, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '001', 'BWB', 6141689175, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '001', 'BWB', 6140508764, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '002', 'BWB', 6140443626, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '808', null, null, null, null, 'M', '002', 'BWB', 6139674655, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '001', 'BWB', 6128438096, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '001', 'BWB', 6116049234, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '002', 'BWB', 6115017998, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '002', 'BWB', 6110894782, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '001', 'BWB', 6097406047, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '001', 'BWB', 6092279055, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '001', 'BWB', 6084418458, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '001', 'BWB', 6082421232, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '002', 'BWB', 6068088306, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '002', 'BWB', 6047180795, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '806', null, null, null, null, 'M', '002', 'BWB', 6046174811, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '002', 'BWB', 6009039658, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '002', 'BWB', 6005072487, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '002', 'BWB', 5988153302, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '001', 'BWB', 5977425121, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '001', 'BWB', 5957345298, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '001', 'BWB', 5956848661, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '002', 'BWB', 5951624610, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '001', 'BWB', 5925532523, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '001', 'BWB', 5921836815, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '809', null, null, null, null, 'M', '002', 'BWB', 5913576232, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '001', 'BWB', 5910440165, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '001', 'BWB', 5898563965, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '002', 'BWB', 5891339678, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '002', 'BWB', 5891259273, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '002', 'BWB', 5890254479, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '002', 'BWB', 5884801758, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '002', 'BWB', 5855398875, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '001', 'BWB', 5855240960, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '002', 'BWB', 5848167714, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '002', 'BWB', 5841725695, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '002', 'BWB', 5840980964, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '002', 'BWB', 5838432863, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '002', 'BWB', 5804862517, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '002', 'BWB', 5784449607, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '001', 'BWB', 5766080221, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '001', 'BWB', 5753892937, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '001', 'BWB', 5742250074, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '001', 'BWB', 5738302160, to_date('31-07-2019', 'dd-mm-yyyy'), null);
commit;
prompt 1800 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '806', null, null, null, null, 'M', '002', 'BWB', 5719424964, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '001', 'BWB', 5712751293, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '002', 'BWB', 5712556998, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '001', 'BWB', 5710355830, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '001', 'BWB', 5689777834, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '002', 'BWB', 5657329263, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '002', 'BWB', 5651494800, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '002', 'BWB', 5642774831, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '002', 'BWB', 5633060800, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '002', 'BWB', 5601981764, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '809', null, null, null, null, 'M', '001', 'BWB', 5596428610, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '002', 'BWB', 5590504956, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '001', 'BWB', 5587032602, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '001', 'BWB', 5534508601, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '002', 'BWB', 5517122392, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '001', 'BWB', 5516664025, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '806', null, null, null, null, 'M', '002', 'BWB', 5492250640, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '002', 'BWB', 5477367568, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '002', 'BWB', 5458037471, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '002', 'BWB', 5448123967, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '001', 'BWB', 5440721800, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '002', 'BWB', 5440572042, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '001', 'BWB', 5419205300, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '001', 'BWB', 5417836300, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '002', 'BWB', 5402202944, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '001', 'BWB', 5391899300, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '001', 'BWB', 5390679300, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '001', 'BWB', 5389932263, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '002', 'BWB', 5384195074, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '002', 'BWB', 5380381206, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '002', 'BWB', 5377211558, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '002', 'BWB', 5375020040, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '001', 'BWB', 5374072300, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '002', 'BWB', 5355096360, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '802', null, null, null, null, 'M', '001', 'BWB', 5337074163, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '806', null, null, null, null, 'M', '002', 'BWB', 5335820156, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '001', 'BWB', 5333512653, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '002', 'BWB', 5332254139, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '001', 'BWB', 5332224300, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '001', 'BWB', 5322399300, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '001', 'BWB', 5319108830, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '001', 'BWB', 5311179300, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '002', 'BWB', 5306338651, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '001', 'BWB', 5304642845, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '002', 'BWB', 5288116312, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '002', 'BWB', 5260897222, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '002', 'BWB', 5252192604, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '002', 'BWB', 5250365967, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '001', 'BWB', 5247156555, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '001', 'BWB', 5231910330, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '001', 'BWB', 5221957609, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '002', 'BWB', 5213677756, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '001', 'BWB', 5208432300, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '001', 'BWB', 5175496486, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '002', 'BWB', 5173936722, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '002', 'BWB', 5165160154, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '001', 'BWB', 5157399300, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '002', 'BWB', 5156080207, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '001', 'BWB', 5132426431, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '002', 'BWB', 5054134623, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '001', 'BWB', 5039559274, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '001', 'BWB', 5032087705, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '001', 'BWB', 5026765807, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '803', null, null, null, null, 'M', '002', 'BWB', 5019015571, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '001', 'BWB', 4983345906, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '802', null, null, null, null, 'M', '002', 'BWB', 4972859049, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '001', 'BWB', 4917398543, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '001', 'BWB', 4911683277, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '001', 'BWB', 4903032185, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '001', 'BWB', 4902063713, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '002', 'BWB', 4879033800, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '002', 'BWB', 4850321554, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '002', 'BWB', 4817204281, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '001', 'BWB', 4811465637, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '001', 'BWB', 4792404957, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '002', 'BWB', 4788360848, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '002', 'BWB', 4766026418, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '001', 'BWB', 4761329685, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '002', 'BWB', 4744927866, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '001', 'BWB', 4737653757, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '002', 'BWB', 4722370793, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '002', 'BWB', 4717754989, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '001', 'BWB', 4690305402, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '002', 'BWB', 4676864235, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '001', 'BWB', 4664659048, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '810', null, null, null, null, 'M', '001', 'BWB', 4663482861, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '001', 'BWB', 4653184461, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '002', 'BWB', 4652925177, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '002', 'BWB', 4636370523, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '002', 'BWB', 4634976222, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '001', 'BWB', 4621327727, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '002', 'BWB', 4619113733, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '001', 'BWB', 4615263977, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '002', 'BWB', 4613836173, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '001', 'BWB', 4607330247, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '001', 'BWB', 4572912784, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '002', 'BWB', 4532052035, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '002', 'BWB', 4524267130, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '002', 'BWB', 4517560131, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '002', 'BWB', 4495480820, to_date('30-04-2020', 'dd-mm-yyyy'), null);
commit;
prompt 1900 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '803', null, null, null, null, 'M', '002', 'BWB', 4471230225, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '001', 'BWB', 4465579698, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '001', 'BWB', 4455192171, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '810', null, null, null, null, 'M', '001', 'BWB', 4434758700, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '809', null, null, null, null, 'M', '002', 'BWB', 4400733612, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '002', 'BWB', 4399280260, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '002', 'BWB', 4383847792, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '002', 'BWB', 4371214062, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '000000', null, null, null, null, 'M', '002', 'BWB', 4360282635, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '001', 'BWB', 4294259654, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '001', 'BWB', 4293064163, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '001', 'BWB', 4274323709, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '001', 'BWB', 4261869681, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '001', 'BWB', 4258015300, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '808', null, null, null, null, 'M', '001', 'BWB', 4241827461, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '808', null, null, null, null, 'M', '002', 'BWB', 4219515116, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '002', 'BWB', 4210036909, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '002', 'BWB', 4199438613, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '001', 'BWB', 4195320300, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '001', 'BWB', 4188715760, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '002', 'BWB', 4175129748, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '808', null, null, null, null, 'M', '001', 'BWB', 4149655451, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '001', 'BWB', 4138716866, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '001', 'BWB', 4131039804, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '001', 'BWB', 4111064824, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '002', 'BWB', 4105182155, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '001', 'BWB', 4089153523, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '001', 'BWB', 4086423460, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '002', 'BWB', 4085034147, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '002', 'BWB', 4084596106, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '802', null, null, null, null, 'M', '002', 'BWB', 4078293320, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '001', 'BWB', 4075364720, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '809', null, null, null, null, 'M', '002', 'BWB', 4063878493, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '002', 'BWB', 4060509497, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '002', 'BWB', 4050031660, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '001', 'BWB', 4024239300, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '001', 'BWB', 2928106905, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '002', 'BWB', 2921441463, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '002', 'BWB', 2919146500, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '002', 'BWB', 2915039289, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '002', 'BWB', 2910654726, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '002', 'BWB', 2910133365, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '001', 'BWB', 2908545637, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '002', 'BWB', 2900449350, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '001', 'BWB', 2900158280, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '001', 'BWB', 2893036486, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '001', 'BWB', 2892003778, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '001', 'BWB', 2889995560, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '002', 'BWB', 2884197177, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '001', 'BWB', 2883210000, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '002', 'BWB', 2882036452, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '001', 'BWB', 2880140000, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '001', 'BWB', 2875367363, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '001', 'BWB', 2866906215, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '002', 'BWB', 2853730344, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '002', 'BWB', 2848161013, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '001', 'BWB', 2838842215, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '002', 'BWB', 2835658682, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '002', 'BWB', 2833715122, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '001', 'BWB', 2826140934, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '002', 'BWB', 2825159634, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '002', 'BWB', 2823051289, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '002', 'BWB', 2809471099, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '002', 'BWB', 2806930567, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '002', 'BWB', 2806135548, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '002', 'BWB', 2805409498, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '001', 'BWB', 2801144500, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '002', 'BWB', 2793273699, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '001', 'BWB', 2791369194, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '002', 'BWB', 2784572997, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '002', 'BWB', 2780224189, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '002', 'BWB', 2776117642, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '002', 'BWB', 2766541439, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '002', 'BWB', 2765944071, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '002', 'BWB', 2763035763, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '001', 'BWB', 2758672838, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '001', 'BWB', 2753007826, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '001', 'BWB', 2751119861, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '002', 'BWB', 2751116667, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '001', 'BWB', 2748125923, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '001', 'BWB', 2741524000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '808', null, null, null, null, 'M', '001', 'BWB', 2727919316, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '002', 'BWB', 2721287973, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '001', 'BWB', 2720215000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '002', 'BWB', 2708535279, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '002', 'BWB', 2702000798, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '001', 'BWB', 2692324215, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '002', 'BWB', 2687548652, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '002', 'BWB', 2683407270, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '002', 'BWB', 2680955893, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '001', 'BWB', 2666274000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '001', 'BWB', 2661132215, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '002', 'BWB', 2660640767, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '002', 'BWB', 2650205521, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '002', 'BWB', 2647829166, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '002', 'BWB', 2645055580, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '001', 'BWB', 2640955215, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '002', 'BWB', 2635162545, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '002', 'BWB', 2633808387, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '001', 'BWB', 2632017771, to_date('31-05-2020', 'dd-mm-yyyy'), null);
commit;
prompt 2000 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '001', 'BWB', 2621546875, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '002', 'BWB', 2621328956, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '001', 'BWB', 2618126020, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '001', 'BWB', 2617120000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '001', 'BWB', 2614498700, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '001', 'BWB', 2613470000, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '001', 'BWB', 2608842215, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '002', 'BWB', 2589968710, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '810', null, null, null, null, 'M', '001', 'BWB', 2578813371, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '001', 'BWB', 2554038684, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '001', 'BWB', 2547373000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '002', 'BWB', 2545459725, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '001', 'BWB', 2544244661, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '002', 'BWB', 2528741035, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '001', 'BWB', 2524617416, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '002', 'BWB', 2507635545, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '002', 'BWB', 2503401065, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '001', 'BWB', 2502400000, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '001', 'BWB', 2500070744, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '001', 'BWB', 2471939910, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '002', 'BWB', 2468059276, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '001', 'BWB', 2449370749, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '002', 'BWB', 2438523701, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '002', 'BWB', 2429913244, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '002', 'BWB', 2422820055, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '002', 'BWB', 2415803241, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '001', 'BWB', 2412491065, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '001', 'BWB', 2411957802, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '002', 'BWB', 2410082366, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '001', 'BWB', 2406611065, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '001', 'BWB', 2403743699, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '002', 'BWB', 2379814394, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '002', 'BWB', 2379743136, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '002', 'BWB', 2373134936, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '001', 'BWB', 2366913334, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '001', 'BWB', 2366800215, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '002', 'BWB', 2366651356, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '002', 'BWB', 2365440015, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '810', null, null, null, null, 'M', '001', 'BWB', 2364965121, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '001', 'BWB', 2358127000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '801', null, null, null, null, 'M', '002', 'BWB', 2357380318, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '001', 'BWB', 2354459000, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '002', 'BWB', 2346229933, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '002', 'BWB', 2341774930, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '001', 'BWB', 2339262215, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '002', 'BWB', 2337325215, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '001', 'BWB', 2336570656, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '001', 'BWB', 2329470000, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '002', 'BWB', 2315893598, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '002', 'BWB', 2312693589, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '001', 'BWB', 2293265065, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '001', 'BWB', 2284706000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '001', 'BWB', 2284063552, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '002', 'BWB', 2283909393, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '002', 'BWB', 2283116499, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '002', 'BWB', 2282798918, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '001', 'BWB', 2282460000, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '001', 'BWB', 2271965065, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '001', 'BWB', 2268716671, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '001', 'BWB', 2267644957, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '001', 'BWB', 2260306494, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '001', 'BWB', 2251596335, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '002', 'BWB', 2246628398, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '002', 'BWB', 2243798121, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '001', 'BWB', 2242727045, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '002', 'BWB', 2241457465, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '001', 'BWB', 2233555067, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '002', 'BWB', 2231083333, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '002', 'BWB', 2216404888, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '002', 'BWB', 2202134662, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '001', 'BWB', 2193174955, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '001', 'BWB', 2188831838, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '001', 'BWB', 2185310826, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '001', 'BWB', 2183279000, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '002', 'BWB', 2183264894, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '001', 'BWB', 2178321570, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '001', 'BWB', 2174322500, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '001', 'BWB', 2168646065, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '001', 'BWB', 2164032869, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '002', 'BWB', 2160900874, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '002', 'BWB', 2148244564, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '001', 'BWB', 2126082000, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '001', 'BWB', 2118387663, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '001', 'BWB', 2107368535, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '002', 'BWB', 2080454699, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '001', 'BWB', 2079789192, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '002', 'BWB', 2065964097, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '002', 'BWB', 2063218065, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '002', 'BWB', 2062659667, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '002', 'BWB', 2062209972, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '001', 'BWB', 2062091065, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '002', 'BWB', 2053074481, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '001', 'BWB', 2039551412, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '001', 'BWB', 2022274000, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '002', 'BWB', 2019356282, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '001', 'BWB', 2017390276, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '001', 'BWB', 2016739020, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '001', 'BWB', 2005305065, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '002', 'BWB', 1992189137, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '001', 'BWB', 1988975065, to_date('31-10-2019', 'dd-mm-yyyy'), null);
commit;
prompt 2100 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '001', 'BWB', 1978388661, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '002', 'BWB', 1968459031, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '002', 'BWB', 1965583531, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '001', 'BWB', 1954970000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '002', 'BWB', 1951880398, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '001', 'BWB', 1949063141, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '801', null, null, null, null, 'M', '002', 'BWB', 1945908048, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '001', 'BWB', 1916013000, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '002', 'BWB', 1914257988, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '001', 'BWB', 1912363000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '002', 'BWB', 1907070916, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '002', 'BWB', 1905431616, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '001', 'BWB', 1902920000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '001', 'BWB', 1901464713, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '001', 'BWB', 1899218606, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '002', 'BWB', 1897454897, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '002', 'BWB', 1893864484, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '001', 'BWB', 1892246677, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '807', null, null, null, null, 'M', '001', 'BWB', 1884098601, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '002', 'BWB', 1883273782, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '802', null, null, null, null, 'M', '001', 'BWB', 1876798000, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '002', 'BWB', 1873331290, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '001', 'BWB', 1872186601, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '002', 'BWB', 1864914667, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '002', 'BWB', 1850403226, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '002', 'BWB', 1849697739, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '001', 'BWB', 1849490000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '001', 'BWB', 1846300000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '001', 'BWB', 1836379000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '002', 'BWB', 1832841613, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '002', 'BWB', 1829326452, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '001', 'BWB', 1820260000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '001', 'BWB', 1806935729, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '002', 'BWB', 1799931353, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100054', '807', null, null, null, null, 'M', '002', 'BWB', 1796490299, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '802', null, null, null, null, 'M', '002', 'BWB', 1795450667, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '001', 'BWB', 1788446875, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '002', 'BWB', 1787879263, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '810', null, null, null, null, 'M', '002', 'BWB', 1785012448, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '001', 'BWB', 1784710663, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '001', 'BWB', 1759580000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100059', '809', null, null, null, null, 'M', '002', 'BWB', 1758987201, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100060', '807', null, null, null, null, 'M', '002', 'BWB', 1732754147, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '002', 'BWB', 1731282072, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '002', 'BWB', 1719766774, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '809', null, null, null, null, 'M', '001', 'BWB', 1712160000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '810', null, null, null, null, 'M', '002', 'BWB', 1708089032, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '002', 'BWB', 1679817097, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '001', 'BWB', 1679550000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '001', 'BWB', 1674570000, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '002', 'BWB', 1661675333, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '001', 'BWB', 1655427219, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '001', 'BWB', 1640488249, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '802', null, null, null, null, 'M', '001', 'BWB', 1640190000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '001', 'BWB', 1635040417, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '001', 'BWB', 1633004382, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '002', 'BWB', 1622191704, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '002', 'BWB', 1621399133, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '002', 'BWB', 1620382558, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '002', 'BWB', 1619311035, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '002', 'BWB', 1616204645, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '002', 'BWB', 1604915910, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '001', 'BWB', 1588570872, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '001', 'BWB', 1574144141, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '002', 'BWB', 1563686188, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '001', 'BWB', 1558876869, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '002', 'BWB', 1558178725, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '002', 'BWB', 1555571625, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '802', null, null, null, null, 'M', '002', 'BWB', 1547188393, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '001', 'BWB', 1539264642, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '805', null, null, null, null, 'M', '001', 'BWB', 1537842729, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '805', null, null, null, null, 'M', '001', 'BWB', 1537365855, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '001', 'BWB', 534237260, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '001', 'BWB', 532616804, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '001', 'BWB', 531652207, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '002', 'BWB', 531550824, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100062', '807', null, null, null, null, 'M', '002', 'BWB', 531068065, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '002', 'BWB', 521601197, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '001', 'BWB', 521123000, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '001', 'BWB', 520813693, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '002', 'BWB', 520454427, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '001', 'BWB', 510013504, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '001', 'BWB', 507742794, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '002', 'BWB', 503155031, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '001', 'BWB', 495017110, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '002', 'BWB', 494002895, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '002', 'BWB', 492169109, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '002', 'BWB', 486748691, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '001', 'BWB', 478738042, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '002', 'BWB', 478331584, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '001', 'BWB', 474969052, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '001', 'BWB', 474696891, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '002', 'BWB', 473198141, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '002', 'BWB', 472940170, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '001', 'BWB', 470580645, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '001', 'BWB', 467767384, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '002', 'BWB', 466881313, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '002', 'BWB', 466827326, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '002', 'BWB', 466705655, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '001', 'BWB', 464849137, to_date('30-06-2020', 'dd-mm-yyyy'), null);
commit;
prompt 2200 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '001', 'BWB', 459700000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '002', 'BWB', 455779436, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '001', 'BWB', 452472055, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '001', 'BWB', 448253810, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '001', 'BWB', 447546042, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '806', null, null, null, null, 'M', '001', 'BWB', 446208463, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '002', 'BWB', 442987645, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '002', 'BWB', 439232983, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '001', 'BWB', 428240051, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '002', 'BWB', 427659613, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '803', null, null, null, null, 'M', '002', 'BWB', 424440686, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '001', 'BWB', 422269879, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '002', 'BWB', 414770958, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '001', 'BWB', 412857356, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '001', 'BWB', 411357000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '002', 'BWB', 410999371, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '001', 'BWB', 410672010, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '001', 'BWB', 410184000, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '001', 'BWB', 409321247, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '002', 'BWB', 405219671, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '001', 'BWB', 402937000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '002', 'BWB', 402371400, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '002', 'BWB', 400254533, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '002', 'BWB', 399680269, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '002', 'BWB', 399341952, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '002', 'BWB', 398136479, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '001', 'BWB', 397643000, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '001', 'BWB', 396886221, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '002', 'BWB', 394815561, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '002', 'BWB', 394671785, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '002', 'BWB', 394329886, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '001', 'BWB', 394205879, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '002', 'BWB', 392454102, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '001', 'BWB', 391840731, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '001', 'BWB', 391247000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '001', 'BWB', 390684823, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '001', 'BWB', 390618051, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '001', 'BWB', 388624354, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '001', 'BWB', 388105486, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '002', 'BWB', 387303928, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '002', 'BWB', 387189633, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '001', 'BWB', 386674683, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '002', 'BWB', 386315643, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '001', 'BWB', 385260000, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '002', 'BWB', 384827213, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '002', 'BWB', 384369254, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '002', 'BWB', 384130281, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '001', 'BWB', 381783066, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '001', 'BWB', 380812340, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '002', 'BWB', 380712276, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '001', 'BWB', 379409734, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '001', 'BWB', 379185374, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '001', 'BWB', 378677179, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '002', 'BWB', 378384043, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '002', 'BWB', 378132772, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '002', 'BWB', 377945784, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '001', 'BWB', 377269130, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '002', 'BWB', 376314836, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '002', 'BWB', 375627986, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '001', 'BWB', 375001000, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '002', 'BWB', 374981735, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '001', 'BWB', 374919000, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '001', 'BWB', 372578562, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '002', 'BWB', 370898640, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '001', 'BWB', 370556000, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '001', 'BWB', 369322387, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '002', 'BWB', 368705216, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '002', 'BWB', 366757397, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '002', 'BWB', 366357488, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '002', 'BWB', 365730602, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '001', 'BWB', 364333607, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '001', 'BWB', 363127000, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '001', 'BWB', 361810486, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '001', 'BWB', 360924997, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '001', 'BWB', 359741000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '002', 'BWB', 359074833, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '002', 'BWB', 357544858, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '002', 'BWB', 356854302, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '001', 'BWB', 356626504, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '001', 'BWB', 355493066, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '002', 'BWB', 354911937, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '001', 'BWB', 354561683, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '001', 'BWB', 354514874, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '002', 'BWB', 350240655, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '002', 'BWB', 349979469, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '002', 'BWB', 349813334, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '002', 'BWB', 349757300, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '001', 'BWB', 349370000, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '002', 'BWB', 349073234, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '002', 'BWB', 347059898, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '001', 'BWB', 345444448, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '002', 'BWB', 345429229, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '001', 'BWB', 345040562, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '002', 'BWB', 344849056, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '001', 'BWB', 343513110, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '002', 'BWB', 342168898, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '002', 'BWB', 340921940, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '002', 'BWB', 340906232, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '001', 'BWB', 340411250, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '002', 'BWB', 339943058, to_date('30-09-2019', 'dd-mm-yyyy'), null);
commit;
prompt 2300 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '001', 'BWB', 337878250, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '002', 'BWB', 337226928, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '001', 'BWB', 335131607, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '001', 'BWB', 333677000, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '002', 'BWB', 332734400, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '001', 'BWB', 330044250, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '001', 'BWB', 329103913, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '002', 'BWB', 327947950, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '002', 'BWB', 326749847, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '001', 'BWB', 325823090, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '001', 'BWB', 325371000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '002', 'BWB', 323865136, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '001', 'BWB', 322805000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '002', 'BWB', 321901100, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '001', 'BWB', 321013000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '002', 'BWB', 320854250, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '002', 'BWB', 319761115, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '001', 'BWB', 313555250, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '002', 'BWB', 313329669, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '001', 'BWB', 312398000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '001', 'BWB', 311775000, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '809', null, null, null, null, 'M', '002', 'BWB', 311594468, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '002', 'BWB', 311177074, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '002', 'BWB', 310538796, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '806', null, null, null, null, 'M', '001', 'BWB', 305724463, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '001', 'BWB', 303506586, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '002', 'BWB', 302975555, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100058', '807', null, null, null, null, 'M', '002', 'BWB', 302036459, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '002', 'BWB', 300129844, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '001', 'BWB', 299645250, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '002', 'BWB', 288453187, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '001', 'BWB', 287151171, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '002', 'BWB', 285639868, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '001', 'BWB', 285341250, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '001', 'BWB', 284721000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '002', 'BWB', 283144900, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '001', 'BWB', 282461586, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '001', 'BWB', 281648134, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '002', 'BWB', 279455533, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '002', 'BWB', 278357872, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '001', 'BWB', 278313693, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '002', 'BWB', 278220404, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '002', 'BWB', 275248989, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '002', 'BWB', 274921629, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '002', 'BWB', 273346728, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '002', 'BWB', 272856961, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '001', 'BWB', 272040800, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '001', 'BWB', 269635000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '001', 'BWB', 269093000, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '002', 'BWB', 266635320, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '001', 'BWB', 266518000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '001', 'BWB', 260246851, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '002', 'BWB', 254853481, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '808', null, null, null, null, 'M', '002', 'BWB', 250333670, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '002', 'BWB', 250257603, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100061', '807', null, null, null, null, 'M', '002', 'BWB', 247262040, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '002', 'BWB', 242956336, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '002', 'BWB', 240421148, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '001', 'BWB', 239303801, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '001', 'BWB', 237597065, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '001', 'BWB', 236188354, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '002', 'BWB', 234924467, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '001', 'BWB', 234029134, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '002', 'BWB', 232490477, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '001', 'BWB', 231653983, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '001', 'BWB', 231249010, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '001', 'BWB', 228724161, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '002', 'BWB', 227478369, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '002', 'BWB', 227107342, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '002', 'BWB', 224763519, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '002', 'BWB', 214357561, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '001', 'BWB', 213848250, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '002', 'BWB', 213712734, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '001', 'BWB', 213158000, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '002', 'BWB', 213102561, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '001', 'BWB', 212991947, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '002', 'BWB', 212342490, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '001', 'BWB', 212021179, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '001', 'BWB', 211997801, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '002', 'BWB', 211696325, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '001', 'BWB', 210559340, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '001', 'BWB', 210440065, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '001', 'BWB', 209911800, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '001', 'BWB', 204884913, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '001', 'BWB', 204721800, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '808', null, null, null, null, 'M', '002', 'BWB', 203659607, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '002', 'BWB', 200194858, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '002', 'BWB', 198602377, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '002', 'BWB', 197062039, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '002', 'BWB', 192294081, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '001', 'BWB', 191057921, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '001', 'BWB', 189798000, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '002', 'BWB', 185268414, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '002', 'BWB', 182228059, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '809', null, null, null, null, 'M', '002', 'BWB', 181663504, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '001', 'BWB', 179980983, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '001', 'BWB', 179423000, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '002', 'BWB', 177340387, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '002', 'BWB', 176517793, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '001', 'BWB', 173998000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
commit;
prompt 2400 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '002', 'BWB', 172946367, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '001', 'BWB', 172546000, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '002', 'BWB', 172234610, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '001', 'BWB', 171880270, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '002', 'BWB', 171775449, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '001', 'BWB', 170253000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '002', 'BWB', 169908267, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '001', 'BWB', 166656000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '002', 'BWB', 166087223, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '002', 'BWB', 165231900, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '002', 'BWB', 162026032, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '001', 'BWB', 161958947, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '002', 'BWB', 161830300, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '001', 'BWB', 159647000, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '002', 'BWB', 159543133, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '002', 'BWB', 158047034, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '001', 'BWB', 158016167, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '002', 'BWB', 156430484, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '810', null, null, null, null, 'M', '001', 'BWB', 155217472, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '002', 'BWB', 154843800, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '001', 'BWB', 153691851, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '001', 'BWB', 153387000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '001', 'BWB', 153125000, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '001', 'BWB', 152436000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '001', 'BWB', 151504000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '002', 'BWB', 148059936, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '002', 'BWB', 146805633, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '002', 'BWB', 146448294, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '002', 'BWB', 144442297, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '001', 'BWB', 140484000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '002', 'BWB', 136641671, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '001', 'BWB', 136621161, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '001', 'BWB', 136051000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '002', 'BWB', 134811900, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '001', 'BWB', 134597000, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '001', 'BWB', 130617000, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '002', 'BWB', 129930965, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '001', 'BWB', 128362921, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '002', 'BWB', 127883000, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '002', 'BWB', 126378725, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '002', 'BWB', 125560368, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '001', 'BWB', 125143599, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '001', 'BWB', 124219000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '002', 'BWB', 123271442, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '001', 'BWB', 123152815, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '001', 'BWB', 121134720, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '001', 'BWB', 119830270, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '001', 'BWB', 116798815, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '001', 'BWB', 116324000, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '002', 'BWB', 114620251, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '002', 'BWB', 112427149, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '002', 'BWB', 112231329, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '001', 'BWB', 111006167, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '001', 'BWB', 108038197, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '002', 'BWB', 107865551, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '002', 'BWB', 107827549, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '810', null, null, null, null, 'M', '001', 'BWB', 106063472, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '002', 'BWB', 105623129, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '001', 'BWB', 104902208, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '002', 'BWB', 103902067, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '001', 'BWB', 101141197, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '001', 'BWB', 100544000, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '001', 'BWB', 95987208, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '002', 'BWB', 94695905, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '002', 'BWB', 93063483, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '002', 'BWB', 92676484, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '001', 'BWB', 92103000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '002', 'BWB', 91596055, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '002', 'BWB', 85802000, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '001', 'BWB', 85122230, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '002', 'BWB', 85003296, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '001', 'BWB', 84974321, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '002', 'BWB', 83343276, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '001', 'BWB', 83190273, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '001', 'BWB', 79242230, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '001', 'BWB', 78654000, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '002', 'BWB', 76923416, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '002', 'BWB', 76400581, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '001', 'BWB', 74706000, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '001', 'BWB', 73062321, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '002', 'BWB', 71872344, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '002', 'BWB', 71688910, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '001', 'BWB', 71493000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '002', 'BWB', 68341700, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '001', 'BWB', 68279000, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '001', 'BWB', 67508191, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '002', 'BWB', 66050903, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '002', 'BWB', 63736152, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '001', 'BWB', 63314000, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '001', 'BWB', 62695000, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '002', 'BWB', 61960706, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '001', 'BWB', 61890273, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '002', 'BWB', 58169212, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '001', 'BWB', 57897589, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '001', 'BWB', 57112359, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '002', 'BWB', 56667690, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '001', 'BWB', 56259000, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '002', 'BWB', 56209800, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '002', 'BWB', 55972684, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '002', 'BWB', 54774419, to_date('30-09-2019', 'dd-mm-yyyy'), null);
commit;
prompt 2500 records committed...
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '002', 'BWB', 54452277, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '002', 'BWB', 54292831, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '002', 'BWB', 53649291, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '002', 'BWB', 52791355, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '001', 'BWB', 52050000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '001', 'BWB', 51932359, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '002', 'BWB', 51715585, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '001', 'BWB', 51673000, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '001', 'BWB', 51367589, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '001', 'BWB', 51178191, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '001', 'BWB', 51033000, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '002', 'BWB', 50742036, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '002', 'BWB', 49598883, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '002', 'BWB', 49183985, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '001', 'BWB', 49154000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '806', null, null, null, null, 'M', '001', 'BWB', 49032000, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '002', 'BWB', 48127067, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '001', 'BWB', 47619000, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '001', 'BWB', 47010000, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '002', 'BWB', 45299385, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100063', '807', null, null, null, null, 'M', '002', 'BWB', 43424898, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100064', '807', null, null, null, null, 'M', '002', 'BWB', 39520198, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '001', 'BWB', 37622000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '002', 'BWB', 35069913, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '001', 'BWB', 32113000, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '001', 'BWB', 31192000, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '002', 'BWB', 30237936, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '002', 'BWB', 29523133, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '002', 'BWB', 29243602, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '001', 'BWB', 29202000, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '002', 'BWB', 28570710, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '002', 'BWB', 28114800, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '001', 'BWB', 28064000, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '002', 'BWB', 27705129, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '001', 'BWB', 27538000, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '001', 'BWB', 27306000, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '001', 'BWB', 27157000, to_date('30-06-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '002', 'BWB', 26723500, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '001', 'BWB', 26295000, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '001', 'BWB', 26290000, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '809', null, null, null, null, 'M', '002', 'BWB', 25648517, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '002', 'BWB', 24991386, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '001', 'BWB', 21300000, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '001', 'BWB', 21045000, to_date('31-07-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '002', 'BWB', 17236633, to_date('30-11-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '001', 'BWB', 16330000, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '002', 'BWB', 13703132, to_date('31-10-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '001', 'BWB', 11912000, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '002', 'BWB', 9206161, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '002', 'BWB', 8961733, to_date('30-09-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '001', 'BWB', 8915000, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '001', 'BWB', 6897000, to_date('31-03-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '002', 'BWB', 6754700, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '002', 'BWB', 6608200, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '002', 'BWB', 6592759, to_date('29-02-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '001', 'BWB', 6530000, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '001', 'BWB', 6354000, to_date('30-04-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '001', 'BWB', 5880000, to_date('31-01-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '002', 'BWB', 5688226, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '001', 'BWB', 5180000, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '001', 'BWB', 5173000, to_date('31-05-2020', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '002', 'BWB', 3904700, to_date('31-07-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '002', 'BWB', 3884600, to_date('31-08-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '001', 'BWB', -71826000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '001', 'BWB', -106555000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '803', null, null, null, null, 'M', '002', 'BWB', -120575023, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '807', null, null, null, null, 'M', '002', 'BWB', -301266403, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '810', null, null, null, null, 'M', '002', 'BWB', -313251771, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '002', 'BWB', -697791319, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '801', null, null, null, null, 'M', '001', 'BWB', -737790000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '002', 'BWB', 3157992736, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '001', 'BWB', -975324000, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '805', null, null, null, null, 'M', '002', 'BWB', -1087973935, to_date('31-12-2019', 'dd-mm-yyyy'), null);
insert into mc_idx_index_data_bl (index_no, org_no, biz_strip_line_cd, dim_cd1, dim_cd2, dim_cd3, batch_freq, index_measure, curr_cd, index_val, etl_dt, etl_timestamp)
values ('FM0100065', '000000', null, null, null, null, 'M', '001', 'BWB', 2841251327, to_date('31-12-2019', 'dd-mm-yyyy'), null);
commit;
